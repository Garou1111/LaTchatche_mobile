import 'package:flutter/material.dart';
import 'package:projet_flutter_411/models/channel.dart';

class Discussions extends StatefulWidget {
  const Discussions({super.key});

  @override
  State<Discussions> createState() => _Discussions();
}

class _Discussions extends State<Discussions> {
  static List<Channel> channels = [
    Channel(name: 'main', messages: 102),
    Channel(name: 'games', messages: 41),
    Channel(name: 'dnd', messages: 70),
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
