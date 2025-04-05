import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:latchatche_mobile/models/api.dart';
import 'package:latchatche_mobile/screens/channel.dart';
import 'package:latchatche_mobile/tchatche.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/channel.dart';

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
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(softWrap: false,'Un salon textuel de discussion vous permet de discuter avec vos amis ou de parfaits inconnus !'),
              const SizedBox(height: 16),
              TextFormField(
                autocorrect: false,
                autofillHints: const [AutofillHints.username],
                controller: _channelNameController,
                validator:
                    (value) =>
                value == null || value.isEmpty
                    ? 'Nom du salon'
                    : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nom du salon",
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
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
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
    );
  }

Future<void> _createChannel() async {
  try {
    Channel newChannel = await Channel.createChannel(
        name: _channelNameController.text);
    // Naviguer vers la page créée
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChannelScreen(channel: newChannel))
    );
  } catch (error) {
    setState(() {
      _errorMessage = error.toString();
    });
  }
  }
}