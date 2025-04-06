import 'package:flutter/material.dart';
import 'package:latchatche_mobile/models/channel.dart';
import 'package:latchatche_mobile/screens/channel.dart';

class CreateChannelScreen extends StatefulWidget {
  const CreateChannelScreen({super.key});

  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreen();
}

class _CreateChannelScreen extends State<CreateChannelScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _channelNameController = TextEditingController();

  String? _errorMessage;
  String? _notice;

  void _normalizeName(String name) {
    // Normalisation du nom
    final normalizedName = name
        .toLowerCase()
        // On retire les caractères spéciaux (en ne comptant pas les accents)
        .replaceAll(RegExp(r'[^a-z0-9éèàêëôöîïùûüç\-_\s]'), '')
        // On remplace les espaces par des tirets
        .replaceAll(RegExp(r'\s'), '-')
        // On retire les tirets en fin de chaîne
        .replaceAll(RegExp(r'-+$'), '');

    setState(() {
      _notice =
          name != normalizedName
              ? 'Certains caractères ne peuvent pas être utilisés.\nLe salon sera créé avec le nom #$normalizedName'
              : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un salon')),
      body: SafeArea(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    const Text(
                      'Un salon textuel de discussion vous permet de discuter avec vos amis ou de parfaits inconnus !',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _channelNameController,
                      autocorrect: false,
                      onChanged: _normalizeName,
                      maxLength: 30,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nom du salon (préfixé par un #)",
                        errorText: _errorMessage,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_notice != null && _notice!.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.deepOrange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _notice!,
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                  ],
                ),
                // maximum space between the button and the text
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _createChannel();
                      }
                    },
                    child: const Text('Créer'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createChannel() async {
    try {
      Channel newChannel = await Channel.createChannel(
        name: _channelNameController.text,
      );
      // on affiche un message de succès
      final msg = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Le salon #${newChannel.name} a été créé !'),
          duration: const Duration(milliseconds: 1250),
        ),
      );

      // on redirige vers le salon
      msg.closed.then((_) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChannelScreen(channel: newChannel),
          ),
        );
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }
}
