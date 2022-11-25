import 'package:firebase_login_project/service/auth.dart';

import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.1;

    return Drawer(
      child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color.fromARGB(255, 4, 42, 66), Colors.indigo],
                  tileMode: TileMode.mirror)),
          child: Column(
            children: <Widget>[
              SizedBox(height: size * 1.5),
              buildMenuItem(
                  text: "Add New Word",
                  icon: Icons.border_color_sharp,
                  size: size,
                  onClicked: () => selectedItem(context, 3)),
              buildMenuItem(text: "Words", icon: Icons.book, size: size, onClicked: () => selectedItem(context, 1)),
              buildMenuItem(
                  text: "Archive", icon: Icons.save_alt_sharp, size: size, onClicked: () => selectedItem(context, 5)),
              buildMenuItem(
                  text: "Speed Test", icon: Icons.timelapse, size: size, onClicked: () => selectedItem(context, 2)),
              buildMenuItem(
                  text: "Translate",
                  icon: Icons.auto_awesome_mosaic,
                  size: size,
                  onClicked: () => selectedItem(context, 4)),
              Expanded(
                child: SizedBox(
                  height: size * 10,
                ),
              ),
              const Divider(
                color: Colors.white70,
              ),
              buildMenuItem(
                  text: "Sign Out", icon: Icons.exit_to_app, size: size, onClicked: () => selectedItem(context, 0))
            ],
          )),
    );
  }

  void selectedItem(BuildContext context, int i) {
    switch (i) {
      case 0:
        Navigator.of(context).pop();
        AuthService _auth = AuthService();
        _auth.signOut();
        try {
          Navigator.pushReplacementNamed(context, '/loginPage');
        } catch (e) {
          Navigator.pushNamed(context, '/loginPage');
        }
        break;
      case 1:
        Navigator.pop(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushNamed(context, '/wordsPage');
        break;
      case 2:
        Navigator.pop(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushNamed(context, '/speedTestPage');
        break;
      case 3:
        Navigator.pop(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case 4:
        Navigator.pop(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushNamed(context, '/translatePage');
        break;
      case 5:
        Navigator.pop(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushNamed(context, '/memoryWordsPage');
        break;
      default:
    }
  }
}

Widget buildMenuItem({required String text, required IconData icon, required double size, VoidCallback? onClicked}) {
  const color = Colors.white;
  const hoverColor = Colors.white70;

  return ListTile(
    leading: Icon(icon, color: color, size: size),
    title: Text(
      text,
      style: const TextStyle(color: color),
    ),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}
