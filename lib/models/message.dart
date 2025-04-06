import 'dart:convert';
import 'package:latchatche_mobile/models/api.dart';
import 'package:latchatche_mobile/models/user.dart';

enum MessageType { defaultType, userAdd, userRemove, channelRename }

class Message {
  int id;
  MessageType type;
  String content;
  DateTime createdAt;
  int? authorId;
  int channelId;
  User? author;

  Message({
    required this.id,
    required this.type,
    required this.content,
    required this.createdAt,
    this.authorId,
    required this.channelId,
    this.author,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'type': String type,
        'content': String content,
        'created_at': String createdAt,
        'author_id': int? authorId,
        'channel_id': int channelId,
        'author':
            {
              'id': int _,
              'username': String authorUsername,
              'created_at': String authorCreatedAt,
            }?,
      } =>
        Message(
          id: id,
          content: content,
          createdAt: DateTime.parse(createdAt),
          type: MessageType.values.firstWhere(
            (e) =>
                (e == MessageType.defaultType && type == 'default') ||
                e.toString() == 'MessageType.${type.toLowerCase()}',
          ),
          authorId: authorId,
          channelId: channelId,
          author:
              authorId == null
                  ? null
                  : User(
                    id: authorId,
                    username: authorUsername,
                    createdAt: DateTime.parse(authorCreatedAt),
                  ),
        ),
      _ => throw const FormatException('Failed to load channels'),
    };
  }

  static Future<List<Message>> findAllForChannel(int channelId) async {
    final response = await Api.get(
      '/channels/$channelId/messages',
      authed: false,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((message) => Message.fromJson(message)).toList();
    } else {
      throw Exception('Failed to load channels');
    }
  }

  static Future<Message> create(int channelId, String content) async {
    final response = await Api.post(
      '/channels/$channelId/messages',
      body: {'content': content},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Message.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to send message');
    }
  }
}
