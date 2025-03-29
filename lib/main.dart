import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latchatche_mobile/screens/welcome.dart';

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
  static final _defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
  );

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: 'La Tchatche',
          home: WelcomeScreen(),
          theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          ),
        );
      },
    );
  }
}
