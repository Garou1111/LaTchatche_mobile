import 'package:flutter/material.dart';
import 'package:latchatche_mobile/tchatche.dart';

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
    // TODO
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Tchatche()),
      // Réinitialiser la pile de navigation
      (Route<dynamic> route) => false,
    );
  }

  // Future<void> _storeToken(String token) async {
  //   final storage = await SharedPreferences.getInstance();
  //   storage.setString('session_token', token);
  // }
}
