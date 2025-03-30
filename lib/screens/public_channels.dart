import 'package:flutter/material.dart';
import 'package:latchatche_mobile/models/channel.dart';
import 'package:latchatche_mobile/screens/channel.dart';

class PublicChannelsScreen extends StatefulWidget {
  const PublicChannelsScreen({super.key});

  @override
  State<PublicChannelsScreen> createState() => _PublicChannelsScreenState();
}

class _PublicChannelsScreenState extends State<PublicChannelsScreen> {
  late Future<List<Channel>> channels;

  @override
  void initState() {
    super.initState();
    channels = Channel.getPublicChannels();
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
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChannelScreen(channel: channel),
                          ),
                        ),
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
