import 'package:flutter/material.dart';
import 'package:latchatche_mobile/models/message.dart';

// TODO: récupérer l'utilisateur courant pour savoir si le message est envoyé ou reçu
class MessageWidget extends StatelessWidget {
  final Message message;
  final List<Message> messages;

  const MessageWidget({
    super.key,
    required this.message,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Colors.grey.shade200,
          ),
          padding: EdgeInsets.all(16),
          child: Text(message.content, style: TextStyle(fontSize: 15)),
        ),
      ),
    );
  }
}
