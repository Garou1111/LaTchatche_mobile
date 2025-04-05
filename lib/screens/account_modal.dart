import 'package:flutter/material.dart';
import 'package:latchatche_mobile/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latchatche_mobile/screens/settings.dart';

class AccountModal extends StatelessWidget {
  const AccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedPreferences = SharedPreferences.getInstance();

    return FutureBuilder<SharedPreferences>(
      future: sharedPreferences,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Dismissible(
            key: const Key('account_modal'),
            direction: DismissDirection.down,
            onDismissed: (direction) => {Navigator.pop(context)},
            child: SimpleDialog(
              title: const Center(child: Text("La Tchatche")),
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _listItem(
                      '${snapshot.data!.getString("account_username")}',
                      subtitle: 'Mon profil',
                      Icons.account_circle_outlined,
                      onTap: () {},
                      context: context, // Pass context to _listItem
                    ),
                    _listItem(
                      'Paramètres',
                      Icons.settings_outlined,
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsScreen()),
                        );
                      },
                      context: context, // Pass context to _listItem
                    ),
                    _listItem(
                      'Déconnexion',
                      Icons.logout_outlined,
                      onTap: () async {
                        snapshot.data?.remove('session_token');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(),
                          ),
                              (route) => false,
                        );
                      },
                      context: context, // Pass context to _listItem
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.grey, height: 1),
                    const SizedBox(height: 8),
                    _listItem(
                      'Code source',
                      Icons.code,
                      onTap: () async {
                        Uri url = Uri.parse(
                          'https://github.com/Garou1111/LaTchatche_mobile',
                        );

                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      context: context, // Pass context to _listItem
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      'Créé par Adam Ben Frej et Clément Voisin\nVersion 1.0.0',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  ListTile _listItem(
      String title,
      IconData icon, {
        required Function() onTap,
        String? subtitle,
        required BuildContext context, // Add context parameter
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 32, right: 32),
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70// Change subtitle color to white in dark mode
              : null, // Default color for light mode (inherits from theme)
        ),
      )
          : null,
    );
  }
}
