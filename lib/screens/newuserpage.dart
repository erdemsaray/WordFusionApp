import 'package:firebase_login_project/service/auth.dart';
import 'package:firebase_login_project/utils/project_variables.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NewUserPage extends StatefulWidget {
  NewUserPage({Key? key}) : super(key: key);

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  static var controllerPasswordA = TextEditingController();
  static var controllerPasswordB = TextEditingController();
  static var controllerEmail = TextEditingController();
  final AuthService _authCreateService = AuthService();
  String inputWrongResult = '';

  @override
  Widget build(BuildContext context) {
    Color secondColor = ColorItems.mainColor;
    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  minimumSize: MaterialStateProperty.all(Size(24, 46))),
              onPressed: () {
                if (passwordControl(controllerPasswordA.text, controllerPasswordB.text)) {
                  if (emailFormatControl(controllerEmail.text)) {
                    _authCreateService.createPerson(controllerEmail.text, controllerPasswordA.text);
                    Navigator.pop(context);
                  } else {
                    inputWrongResult = 'Please check your e-mail format';
                  }
                } else {
                  inputWrongResult = 'Passwords must be at least 6 characters and equals';
                }

                setState(() {});
              },
              child: const Text(
                'Create Account',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );

    final password = TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: controllerPasswordA,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordAgain = TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: controllerPasswordB,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Retry Password',
        hintStyle: TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: controllerEmail,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color.fromARGB(255, 0, 0, 0), Colors.indigo],
                tileMode: TileMode.mirror)),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 250, child: Lottie.asset('assets/lottie/createperson.json')),
                  SizedBox(
                    height: 7,
                  ),
                  email,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: password,
                  ),
                  passwordAgain,
                  Text(
                    inputWrongResult,
                    style: TextStyle(color: Colors.red),
                  ),
                  loginButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool passwordControl(String passwordA, String passwordB) {
    if (passwordA == passwordB) {
      if (passwordA.length >= 6) return true;
    }
    return false;
  }

  bool emailFormatControl(String email) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }
}
