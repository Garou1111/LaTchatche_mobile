import 'package:flutter/material.dart';
import 'package:projet_flutter_411/models/channel.dart';

class PublicChannels extends StatefulWidget {
  const PublicChannels({super.key});

  @override
  State<PublicChannels> createState() => _PublicChannels();
}

class _PublicChannels extends State<PublicChannels> {
  static List<Channel> channels = [
    Channel(name: 'gheb', messages: 58),
    Channel(name: 'memes', messages: 24),
    Channel(name: 'thing', messages: 32),
    Channel(name: 'adam', messages: 69),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          channels.map((Channel channel) {
            return ListTile(
              leading: Icon(Icons.tag),
              title: Text(channel.name),
              subtitle: Text('${channel.messages} messages'),
            );
          }).toList(),
    );
  }
}
