import 'package:firebase_login_project/service/auth.dart';
import 'package:firebase_login_project/utils/project_variables.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  static var controllerEmail = TextEditingController();
  final AuthService _authCreateService = AuthService();
  String inputWrongResult = '';

  @override
  Widget build(BuildContext context) {
    Color secondColor = ColorItems.mainColor;
    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: secondColor, padding: const EdgeInsets.all(15)),
              onPressed: () {
                setState(() {
                  _authCreateService.passwordReset(controllerEmail.text);
                  print(controllerEmail.text);
                  Navigator.pop(context);
                });
              },
              child: const Text(
                'Send password reset e-mail',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
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
      backgroundColor: Colors.white,
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
                  SizedBox(height: 250, child: Lottie.asset('assets/lottie/resetpassword.json')),
                  SizedBox(
                    height: 7,
                  ),
                  email,
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

  bool emailFormatControl(String email) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }
}
