import 'package:avatar_view/avatar_view.dart';
import 'package:firebase_login_project/service/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService _authService = AuthService();

  var controllerEmail = TextEditingController();
  var controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: controllerEmail,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: controllerPassword,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(onPrimary: Colors.lightBlueAccent, padding: const EdgeInsets.all(15)),
        onPressed: () {
          _authService.signIn(controllerEmail.text, controllerPassword.text).then((value) {
            return Navigator.pushReplacementNamed(context, '/homePage');
          });
        },
        child: const Text(
          'Log In',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );

    final forgotLabel = TextButton(
      child: const Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    final gmailSign = TextButton(onPressed: () {}, child: Text("Sign with Gmail"));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: false,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 100, top: 140),
          children: <Widget>[
            const Icon(
              Icons.person,
              size: 100,
            ),
            const SizedBox(height: 20.0),
            email,
            const SizedBox(height: 8.0),
            password,
            const SizedBox(height: 10.0),
            loginButton,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail_outline),
                gmailSign,
                Icon(Icons.lock_reset),
                forgotLabel,
              ],
            )
          ],
        ),
      ),
    );
  }
}
