import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latchatche_mobile/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paramètres')),
      body: Column(
        children: [
          ListTile(
            title: Text('Thème Sombre'),
            trailing: Switch(
              value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          ListTile(
            subtitle: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text('Clair'),
                  value: ThemeMode.light,
                  groupValue: Provider.of<ThemeProvider>(context).themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text('Sombre'),
                  value: ThemeMode.dark,
                  groupValue: Provider.of<ThemeProvider>(context).themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(value);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
