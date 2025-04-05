import 'dart:convert';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:latchatche_mobile/models/api.dart';
import 'package:latchatche_mobile/screens/welcome.dart';
import 'package:latchatche_mobile/tchatche.dart';
import 'package:provider/provider.dart';  // Import provider
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_provider.dart';  // Import ThemeProvider

Future main() async {
  // On charge les variables d'environnement
  await dotenv.load(fileName: ".env");

  // Si la variable d'environnement n'est pas trouvée, on lève une exception
  if (dotenv.env['BASE_URL'] == null) {
    throw Exception('BASE_URL not found in .env file');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  static final _defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
  );

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return DynamicColorBuilder(
          builder: (lightColorScheme, darkColorScheme) {
            return MaterialApp(
              title: 'La Tchatche',
              theme: ThemeData(
                colorScheme: lightColorScheme ?? _defaultLightColorScheme,
              ),
              darkTheme: ThemeData(
                colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
              ),
              themeMode: themeProvider.themeMode,  // Use themeMode from ThemeProvider
              home: FutureBuilder(
                future: _checkLogin(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // si la connexion est en cours, on affiche un indicateur de chargement
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erreur de connexion'));
                  } else if (snapshot.data == true) {
                    // si l'utilisateur est connecté, on affiche l'écran principal
                    return const Tchatche();
                  } else {
                    // sinon, on affiche l'écran de connexion
                    return const WelcomeScreen();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _checkLogin() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('session_token');

    if (token == null) {
      return false;
    }

    // On envoie une requête au serveur pour vérifier si le token est valide
    Response response = await Api.get('/me', loginRedirect: false);

    if (response.statusCode == 401) {
      // Le token est invalide
      return false;
    }

    // on met en cache la réponse
    final jsonResponse = jsonDecode(response.body);
    await sharedPreferences.setInt('account_id', jsonResponse['id']);
    await sharedPreferences.setString(
      'account_username',
      jsonResponse['username'],
    );

    return true;
  }
}
