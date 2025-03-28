import 'package:flutter/material.dart';
import 'package:latchatche_mobile/models/channel.dart';

class PublicChannels extends StatefulWidget {
  const PublicChannels({super.key});

  @override
  State<PublicChannels> createState() => _PublicChannels();
}

class _PublicChannels extends State<PublicChannels> {
  late Future<List<Channel>> channels;

  @override
  void initState() {
    super.initState();
    channels = Channel.getAllPublic();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Channel>>(
      future: channels,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children:
                snapshot.data!.map((Channel channel) {
                  return ListTile(
                    leading: Icon(Icons.tag),
                    title: Text(channel.name),
                    subtitle: Text('${channel.messageCount} messages'),
                  );
                }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        //  Montrer un indicateur de chargement pendant le chargement des données
        return const CircularProgressIndicator();
      },
    );
  }
}
