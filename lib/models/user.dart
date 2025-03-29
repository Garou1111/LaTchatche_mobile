// import 'dart:convert';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

class User {
  int id;
  String username;
  DateTime createdAt;

  User({required this.id, required this.username, required this.createdAt});
  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': var id, 'username': var username, 'created_at': var createdAt} =>
        User(id: id, username: username, createdAt: DateTime.parse(createdAt)),
      _ => throw const FormatException('Failed to load user'),
    };
  }
}
