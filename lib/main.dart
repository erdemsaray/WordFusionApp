import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login_project/screens/homepage.dart';
import 'package:firebase_login_project/screens/loginpage.dart';
import 'package:firebase_login_project/screens/newuserpage.dart';
import 'package:firebase_login_project/screens/speedtestpage.dart';
import 'package:firebase_login_project/screens/translatepage.dart';
import 'package:firebase_login_project/screens/wordspage.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
// Define a widget
    Widget firstWidget;

// Assign widget based on availability of currentUser
    if (firebaseUser != null) {
      firstWidget = const HomePage();
    } else {
      firstWidget = const LoginPage();
    }

    return MaterialApp(
        title: 'Firebase',
        theme: ThemeData(backgroundColor: Colors.black),
        debugShowCheckedModeBanner: false,
        home: firstWidget,
        routes: {
          '/homePage': (context) => const HomePage(),
          '/loginPage': (context) => const LoginPage(),
          '/newUserPage': (context) => NewUserPage(),
          '/wordsPage': (context) => WordsPage(),
          '/translatePage': (context) => const TranslatePage(),
          '/speedTestPage': (context) => SpeedTestPage(),
        });
  }
}
