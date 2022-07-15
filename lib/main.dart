import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login_project/screens/homepage.dart';
import 'package:firebase_login_project/screens/loginpage.dart';
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
    return MaterialApp(
        title: 'Firebase',
        theme: ThemeData(backgroundColor: Colors.black),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {
          '/homePage': (context) => HomePage(),
          '/loginPage': (context) => const LoginPage(),
        });
  }
}
