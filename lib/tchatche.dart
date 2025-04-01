import 'package:flutter/material.dart';
import 'package:latchatche_mobile/screens/account_modal.dart';
import 'package:latchatche_mobile/screens/discussions.dart';
import 'package:latchatche_mobile/screens/public_channels.dart';

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
  int currentPageIndex = 0;

  static List<Page> pages = <Page>[
    Page(
      icon: Icon(Icons.tag),
      title: 'Discussions',
      widget: DiscussionsScreen(),
    ),
    Page(
      icon: Icon(Icons.public),
      title: 'Salons publics',
      widget: PublicChannelsScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(pages.elementAt(currentPageIndex).title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Créer un salon',
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            tooltip: "Mon profil",
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return const AccountModal();
                },
              );
            },
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
      body: SingleChildScrollView(
        child: pages.elementAt(currentPageIndex).widget,
      ),
    );
  }
}
