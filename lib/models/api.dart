import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latchatche_mobile/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static Future<String> getToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('session_token');

    if (token == null) {
      throw Exception('No session token found');
    }

    return token;
  }

  // Requête GET pour récupérer les données
  static Future<http.Response> get(
    String resource, {
    bool authed = true,
    bool loginRedirect = true,
  }) async {
    String? token;
    if (authed) {
      token = await getToken();
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['BASE_URL']}$resource'),
      headers: {
        // Si l'utilisateur est connecté, on ajoute le token dans les headers
        if (authed && token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // si le token est expiré ou invalide
    // on navigue vers la page de login et on supprime le token
    if (response.statusCode == 401 && loginRedirect) {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      BuildContext? context = navigatorKey.currentContext;

      if (context != null && context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('session_token');
      }
    }

    return response;
  }

  // Requête POST pour envoyer des données
  static Future<http.Response> post(
    String resource,
    Map<String, dynamic> body, {
    bool authed = true,
    bool loginRedirect = true,
  }) async {
    String? token;
    if (authed) {
      token = await getToken();
    }

    final response = await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}$resource'),
      headers: {
        // Si l'utilisateur est connecté, on ajoute le token dans les headers
        if (authed && token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    // si le token est expiré ou invalide
    // on navigue vers la page de login et on supprime le token
    if (response.statusCode == 401 && loginRedirect) {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      BuildContext? context = navigatorKey.currentContext;

      if (context != null && context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('session_token');
      }
    }

    return response;
  }
}
