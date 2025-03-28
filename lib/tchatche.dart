import 'package:flutter/material.dart';
import 'package:projet_flutter_411/pages/discussions.dart';
import 'package:projet_flutter_411/pages/public_channels.dart';

class Tchatche extends StatefulWidget {
  const Tchatche({super.key});

  @override
  State<Tchatche> createState() => _TchatcheState();
}

class Page {
  final String title;
  final Icon icon;
  final Widget widget;

  Page({required this.title, required this.icon, required this.widget});
}

class _TchatcheState extends State<Tchatche> {
  int currentPageIndex = 1;

  static List<Page> pages = <Page>[
    Page(icon: Icon(Icons.tag), title: 'Discussions', widget: Discussions()),
    Page(
      icon: Icon(Icons.public),
      title: 'Salons publics',
      widget: PublicChannels(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pages.elementAt(currentPageIndex).title),
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
        destinations:
            pages.map((Page page) {
              return NavigationDestination(icon: page.icon, label: page.title);
            }).toList(),
      ),
      body: pages.elementAt(currentPageIndex).widget,
    );
  }
}
