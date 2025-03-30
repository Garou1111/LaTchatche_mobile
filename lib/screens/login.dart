import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latchatche_mobile/tchatche.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Se connecter')),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextFormField(
                autocorrect: false,
                autofillHints: const [AutofillHints.username],
                controller: _usernameController,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Veuillez entrer votre nom d\'utilisateur'
                            : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nom d'utilisateur",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                autocorrect: false,
                autofillHints: const [AutofillHints.password],
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Veuillez entrer votre mot de passe'
                            : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Mot de passe',
                  suffixIcon: IconButton(
                    icon:
                        _showPassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showPassword,
                // show password toggle
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null)
                Column(
                  children: [
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _login();
                    }
                  },
                  child: const Text('Se connecter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}/login'),
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String;

      // On stocke le token dans le stockage local
      _storeToken(token);

      // Naviguer vers la page d'accueil
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Tchatche()),
        (Route<dynamic> route) => false,
      );
    } else {
      final data = jsonDecode(response.body);
      final error = data['error'] as String;
      setState(() {
        _errorMessage = error;
      });
    }
  }

  Future<void> _storeToken(String token) async {
    final storage = await SharedPreferences.getInstance();
    storage.setString('session_token', token);
  }
}
