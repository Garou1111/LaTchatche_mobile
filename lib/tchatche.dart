import 'package:flutter/material.dart';
import 'package:latchatche_mobile/screens/account_modal.dart';
import 'package:latchatche_mobile/screens/create_channel.dart';
import 'package:latchatche_mobile/screens/discussions.dart';
import 'package:latchatche_mobile/screens/public_channels.dart';

class Tchatche extends StatefulWidget {
  const Tchatche({super.key});

  @override
  State<Tchatche> createState() => _TchatcheState();
}

class Page {
  final String title;
  final IconData icon;
  final IconData? selectedIcon;
  final Widget widget;

  Page({
    required this.title,
    required this.icon,
    required this.selectedIcon,
    required this.widget,
  });
}

class _TchatcheState extends State<Tchatche> {
  int currentPageIndex = 0;

  static final List<Page> pages = <Page>[
    Page(
      icon: Icons.tag_outlined,
      selectedIcon: Icons.tag,
      title: 'Discussions',
      widget: DiscussionsScreen(),
    ),
    Page(
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      title: 'Salons publics',
      widget: PublicChannelsScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 600
        ? Scaffold(
          appBar: _buildAppBar(context),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations:
                pages.asMap().entries.map((entry) {
                  int index = entry.key;
                  Page page = entry.value;
                  return NavigationDestination(
                    icon: Icon(
                      currentPageIndex == index ? page.selectedIcon : page.icon,
                    ),
                    label: page.title,
                  );
                }).toList(),
          ),
          body: SingleChildScrollView(
            child: pages.elementAt(currentPageIndex).widget,
          ),
        )
        : Scaffold(
          body: Row(
            children: <Widget>[
              NavigationRail(
                leading: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child:
                      MediaQuery.of(context).size.width >= 800
                          ? Text(
                            'La Tchatche',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headlineSmall,
                          )
                          : Icon(Icons.message_outlined),
                ),
                labelType:
                    MediaQuery.of(context).size.width >= 800
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.selected,
                extended: MediaQuery.of(context).size.width >= 800,
                groupAlignment: -1,
                destinations:
                    pages.asMap().entries.map((entry) {
                      int index = entry.key;
                      Page page = entry.value;

                      return NavigationRailDestination(
                        icon: Icon(
                          currentPageIndex == index
                              ? page.selectedIcon
                              : page.icon,
                        ),
                        label: Text(page.title),
                      );
                    }).toList(),
                selectedIndex: currentPageIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Column(
                  children: [
                    _buildAppBar(context),
                    SingleChildScrollView(
                      child: pages.elementAt(currentPageIndex).widget,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(pages.elementAt(currentPageIndex).title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Créer un salon',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateChannelScreen(),
              ),
            );
          },
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
    );
  }
}
