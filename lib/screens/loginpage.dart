import 'package:firebase_login_project/service/auth.dart';
import 'package:firebase_login_project/utils/project_variables.dart';
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
  bool wrongVisibility = false;
  Color secondColor = ColorItems.mainColor;

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
        style: ElevatedButton.styleFrom(primary: secondColor, padding: const EdgeInsets.all(15)),
        onPressed: () {
          _authService.signIn(controllerEmail.text, controllerPassword.text).then((value) {
            if (value != null) {
              Navigator.pushReplacementNamed(context, '/homePage');
            } else {
              setState(() {
                wrongVisibility = true;
              });
            }
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

    final newUserLabel = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("Don't have an Account?"),
      TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/newUserPage');
          },
          child: const Text("Sign Up"))
    ]);

    final gmailSign = TextButton(
      onPressed: () {},
      child: const Text("Sign with Gmail"),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: false,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 100),
          children: <Widget>[
            Expanded(child: SizedBox(height: 70)),
            Image.asset('assets/loginpageimage.png'),
            const SizedBox(height: 20.0),
            email,
            const SizedBox(height: 8.0),
            password,
            const SizedBox(height: 5.0),
            Visibility(
                visible: wrongVisibility,
                child: const Text(
                  "Wrong email or password",
                  style: TextStyle(color: Colors.red),
                )),
            loginButton,
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mail_outline),
                    gmailSign,
                    const Icon(Icons.lock_reset),
                    forgotLabel,
                  ],
                ),
                newUserLabel,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
