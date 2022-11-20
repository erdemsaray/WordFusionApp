import 'package:firebase_login_project/service/auth.dart';
import 'package:firebase_login_project/utils/project_variables.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
//comment satırı

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  var controllerEmail = TextEditingController();
  var controllerPassword = TextEditingController();
  bool wrongVisibility = false;
  Color secondColor = ColorItems.mainColor;
  String validationText = ' ';

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    final email = TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: controllerEmail,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: controllerPassword,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = SizedBox(
      width: size,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
          Colors.indigo,
        )),
        onPressed: () {
          _authService.signIn(controllerEmail.text, controllerPassword.text).then((value) {
            if (value != null) {
              Navigator.pushReplacementNamed(context, '/homePage');
            } else {
              setState(() {
                validationText = "Please check your e-mail or password";
              });
            }
          });
        },
        child: const Text(
          'Log In',
          style: TextStyle(color: Colors.white70, fontSize: 20),
        ),
      ),
    );

    final forgotLabel = TextButton(
      child: const Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        validationText = '';
        Navigator.pushNamed(context, '/resetPasswordPage');
      },
    );

    final newUserLabel = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("Don't have an Account?"),
      TextButton(
          onPressed: () {
            validationText = ' ';
            Navigator.pushNamed(context, '/newUserPage');
          },
          child: const Text("Sign Up"))
    ]);

    final gmailSign = TextButton(
      onPressed: () async {
        await _authService.signWithGmailAccount().then(
          (value) {
            if (value != null) {
              Navigator.pushReplacementNamed(context, '/homePage');
            }
          },
        );
      },
      child: const Text("Sign with Gmail"),
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
              reverse: true,
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: SizedBox(
                height: size * 1.40,
                child: Column(
                  children: <Widget>[
                    Expanded(child: SizedBox(height: size / 2)),
                    SizedBox(height: 250, child: Lottie.asset('assets/lottie/login.json')),
                    const SizedBox(height: 20.0),
                    email,
                    const SizedBox(height: 8.0),
                    password,
                    const SizedBox(height: 5.0),
                    Flexible(
                      child: Text(
                        validationText,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
              )),
        ),
      ),
    );
  }
}
