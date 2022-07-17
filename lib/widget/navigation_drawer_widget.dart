import 'package:firebase_login_project/service/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.1;

    return Drawer(
      child: Material(
          color: Color.fromARGB(255, 255, 148, 0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: size * 1.5),
              buildMenuItem(text: "Kelimeler", icon: Icons.book, size: size, onClicked: () => selectedItem(context, 1)),
              buildMenuItem(
                  text: "Hızlı Tekrar", icon: Icons.timelapse, size: size, onClicked: () => selectedItem(context, 2)),
              buildMenuItem(
                  text: "Günlük",
                  icon: Icons.border_color_sharp,
                  size: size,
                  onClicked: () => selectedItem(context, 3)),
              buildMenuItem(
                  text: "Ajanda",
                  icon: Icons.auto_awesome_mosaic,
                  size: size,
                  onClicked: () => selectedItem(context, 4)),
              SizedBox(
                height: size * 7,
              ),
              Divider(
                color: Colors.white70,
              ),
              buildMenuItem(
                  text: "Sign Out", icon: Icons.exit_to_app, size: size, onClicked: () => selectedItem(context, 0))
            ],
          )),
    );
  }

  void selectedItem(BuildContext context, int i) {
    Navigator.popUntil(context, ModalRoute.withName("/homePage"));
    switch (i) {
      case 0:
        AuthService _auth = AuthService();
        _auth.signOut();
        Navigator.pushReplacementNamed(context, '/loginPage');
        break;
      case 1:
        Navigator.pushNamed(context, '/wordsPage');

        break;
      default:
    }
  }
}

Widget buildMenuItem({required String text, required IconData icon, required double size, VoidCallback? onClicked}) {
  final color = Colors.white;
  final hoverColor = Colors.white70;

  return ListTile(
    leading: Icon(icon, color: color, size: size),
    title: Text(
      text,
      style: TextStyle(color: color),
    ),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}
