import 'package:flutter/material.dart';
import 'package:projet_flutter_411/pages/discussions.dart';
import 'package:projet_flutter_411/pages/public_channels.dart';

class Tchatche extends StatefulWidget {
  const Tchatche({super.key});

  @override
  State<Tchatche> createState() => _TchatcheState();
}

class _TchatcheState extends State<Tchatche> {
  int currentPageIndex = 0;

  static const List<Widget> pages = <Widget>[Discussions(), PublicChannels()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussions'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
            tooltip: 'Créer un salon',
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle_outlined),
            tooltip: "Mon profil",
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.tag), label: 'Discussions'),
          NavigationDestination(
            icon: Icon(Icons.public),
            label: 'Salons publics',
          ),
        ],
      ),
      body: pages.elementAt(currentPageIndex),
    );
  }
}
