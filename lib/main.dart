import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latchatche_mobile/tchatche.dart';

Future main() async {
  // On charge les variables d'environnement
  await dotenv.load(fileName: ".env");

  // Si la variable d'environnement n'est pas trouvée, on lève une exception
  if (dotenv.env['BASE_URL'] == null) {
    throw Exception('BASE_URL not found in .env file');
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Tchatche',
      initialRoute: '/',
      home: Tchatche(),
    );
  }
}
