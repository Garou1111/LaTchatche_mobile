import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
        'id': var id,
        'name': var name,
        'created_at': var createdAt,
        'type': var type,
        'owner_id': var ownerId,
        'owner_username': var ownerUsername,
        'member_count': var memberCount,
        'message_count': var messageCount,
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

  static Future<List<Channel>> getAllPublic() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['BASE_URL']}/channels'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((channel) => Channel.fromJson(channel)).toList();
    } else {
      throw Exception('Failed to load channels');
    }
  }
}
