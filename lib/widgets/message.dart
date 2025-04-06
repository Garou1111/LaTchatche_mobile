import 'package:flutter/material.dart';
import 'package:latchatche_mobile/models/message.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final List<Message> messages;
  final bool isSentByMe;

  const MessageWidget({
    super.key,
    required this.message,
    required this.messages,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: isSentByMe ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color:
                isSentByMe
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceDim,
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            message.content,
            style: TextStyle(
              fontSize: 15,
              color:
                  isSentByMe
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
