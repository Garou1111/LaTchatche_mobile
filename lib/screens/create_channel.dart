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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un salon')),
      body: SafeArea(
        child: Form(
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
                      maxLength: 30,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nom du salon (préfixé par un #)",
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_errorMessage != null)
                      Column(
                        children: [
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
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
      // Naviguer vers la page créée
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChannelScreen(channel: newChannel),
        ),
      );
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }
}
