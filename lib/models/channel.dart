import 'dart:convert';
import 'package:latchatche_mobile/models/api.dart';

enum ChannelType { public, private, direct }

class Channel {
  int id;
  String name;
  DateTime createdAt;
  ChannelType type;
  int ownerId;
  String ownerUsername;
  int memberCount;
  int messageCount;

  Channel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.type,
    required this.ownerId,
    required this.ownerUsername,
    required this.memberCount,
    required this.messageCount,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'created_at': String createdAt,
        'type': String type,
        'owner_id': int ownerId,
        'owner_username': String ownerUsername,
        'member_count': int memberCount,
        'message_count': int messageCount,
      } =>
        Channel(
          id: id,
          name: name,
          createdAt: DateTime.parse(createdAt),
          type: ChannelType.values.firstWhere(
            (e) => e.toString() == 'ChannelType.${type.toLowerCase()}',
          ),
          ownerId: ownerId,
          ownerUsername: ownerUsername,
          memberCount: memberCount,
          messageCount: messageCount,
        ),
      _ => throw const FormatException('Failed to load channels'),
    };
  }

  static Future<List<Channel>> getMyChannels() async {
    final response = await Api.get('/channels');

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((channel) => Channel.fromJson(channel)).toList();
    } else {
      throw Exception('Failed to load channels');
    }
  }

  static Future<List<Channel>> getPublicChannels() async {
    final response = await Api.get('/channels/public');

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((channel) => Channel.fromJson(channel)).toList();
    } else {
      throw Exception('Failed to load channels');
    }
  }

  static Future<Channel> getChannel(int channelId) async {
    final response = await Api.get('/channels/$channelId', authed: false);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return Channel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load channel');
    }
  }

  static Future<Channel> createChannel({ required String name }) async {
    final response = await Api.post('/channels', {
      'name': name,
      'type': 'public',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return Channel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create channel');
    }
  }
}
