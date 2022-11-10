import 'package:firebase_login_project/service/auth.dart';
import 'package:firebase_login_project/utils/project_variables.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> with TickerProviderStateMixin {
  AnimationController? lottieController;
  static var controllerEmail = TextEditingController();
  final AuthService _authCreateService = AuthService();
  String inputWrongResult = '';

  @override
  void initState() {
    super.initState();

    lottieController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    lottieController!.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        lottieController!.reset();
      }
    });
  }

  @override
  void dispose() {
    lottieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    bool progressAnimateIsActive = false;
    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  minimumSize: MaterialStateProperty.all(const Size(24, 46))),
              onPressed: () {
                setState(() {
                  if (emailFormatControl(controllerEmail.text)) {
                    _authCreateService.passwordReset(controllerEmail.text);
                    progressAnimateIsActive = true;
                    lottieController!.forward();
                    controllerEmail.clear();
                  } else {
                    inputWrongResult = 'Please check your e-mail format.';
                  }
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
        hintStyle: const TextStyle(color: Colors.white70),
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
                  const SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                    width: widthSize,
                    height: 40,
                    child: Lottie.asset(
                      'assets/lottie/turquiseprogressbar.json',
                      fit: BoxFit.fill,
                      repeat: false,
                      animate: false,
                      controller: lottieController,
                      onLoaded: (p0) {},
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  email,
                  Text(
                    inputWrongResult,
                    style: const TextStyle(color: Colors.red),
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
