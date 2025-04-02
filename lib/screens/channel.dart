import 'package:flutter/material.dart';
import 'package:latchatche_mobile/models/channel.dart';
import 'package:latchatche_mobile/models/message.dart';
import 'package:latchatche_mobile/widgets/message.dart';

class ChannelScreen extends StatefulWidget {
  final Channel channel;

  const ChannelScreen({super.key, required this.channel});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  // Future pour la liste des messages
  late Future<List<Message>> _futureMessages;
  List<Message> _messages = [];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  // Si le bouton d'envoi est activé ou non
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // on initialise la liste des messages
    _futureMessages = Message.findAllForChannel(widget.channel.id);
  }

  void _addMessage() async {
    if (_textEditingController.text.isNotEmpty) {
      Message newMessage = await Message.create(
        widget.channel.id,
        _textEditingController.text,
      );
      setState(() {
        _messages.add(newMessage);
        // on désactive le bouton d'envoi
        _isButtonEnabled = false;
      });
      // on efface le contenu du champ de texte
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('#${widget.channel.name}'),
            Text(
              '${widget.channel.memberCount} membre(s) • Opéré par ${widget.channel.ownerUsername}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Inviter au salon',
            onPressed: () {},
            icon: Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: FutureBuilder<List<Message>>(
                future: _futureMessages,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // on ajoute les infos dans _messages
                    _messages = snapshot.data ?? [];

                    // on scrolle tout en bas
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.jumpTo(
                          _scrollController.position.maxScrollExtent,
                        );
                      }
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder:
                          (context, index) => MessageWidget(
                            message: _messages[index],
                            messages: _messages,
                          ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  //  Montrer un indicateur de chargement pendant le chargement des données
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textEditingController,
                    onChanged: (value) {
                      // si le champ de texte est vide, le bouton d'envoi est désactivé
                      setState(() {
                        _isButtonEnabled = value.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide.none,
                      ),
                      // fillColor: Theme.of(context).colorScheme.primaryContainer,
                      filled: true,
                      hintText:
                          'Envoyez un message dans #${widget.channel.name}',
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    // on montre le bouton envoyer plutôt que retour à la ligne
                    textInputAction: TextInputAction.go,
                    // dès que l'utilisateur envoie le message (appui sur Entrée)
                    onFieldSubmitted: (_) => _addMessage(),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton.filled(
                  tooltip: 'Envoyer',
                  padding: const EdgeInsets.all(12),
                  disabledColor: Theme.of(context).colorScheme.primary,
                  color: Theme.of(context).colorScheme.onPrimary,
                  icon: const Icon(Icons.send),
                  // le bouton d'envoi est désactivé si le champ de texte est vide
                  onPressed: _isButtonEnabled ? _addMessage : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
