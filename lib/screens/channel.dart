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
  late Future<List<Message>> messages;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messages = Message.findAllForChannel(widget.channel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('#${widget.channel.name}')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: FutureBuilder<List<Message>>(
                future: messages,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
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
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder:
                          (context, index) => MessageWidget(
                            message: snapshot.data![index],
                            messages: snapshot.data!,
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
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: TextFormField(
              decoration: InputDecoration(
                border:
                // outlined border with more rounded corners
                const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                ),
                hintText: 'Envoyez un message dans #${widget.channel.name}',
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
