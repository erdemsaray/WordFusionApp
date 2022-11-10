import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_login_project/service/word_service.dart';
import 'package:firebase_login_project/utils/project_variables.dart';
import 'package:firebase_login_project/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color secondColor = ColorItems.mainColor;

  var controllerWord = TextEditingController();
  var controllerMean = TextEditingController();
  final _wordService = WordService();

  var lastWordStatus = false;
  String statusText = '';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedTextKit(
          animatedTexts: [WavyAnimatedText("Add a New Word")],
        ),
        centerTitle: true,
      ),
      body: Container(
        height: heightSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.green.shade400,
            Colors.blue.shade900,
          ]),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 40, left: 40),
            child: SingleChildScrollView(
              reverse: false,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Lottie.asset('assets/lottie/girlanddog.json'),
                    //Image.asset('assets/anewword.png'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        controller: controllerWord,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Word',
                          hintStyle: const TextStyle(color: Colors.white54),
                          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Cannot be blank';
                            } else {
                              return null;
                            }
                          }
                        },
                      ),
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      controller: controllerMean,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Mean',
                        hintStyle: const TextStyle(color: Colors.white54),
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'Cannot be blank';
                          } else {
                            return null;
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Visibility(
                        visible: lastWordStatus,
                        child: Text(
                          statusText,
                          style: const TextStyle(color: Colors.yellow),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () {
                                final icerikUygunMu = formKey.currentState?.validate();

                                if (icerikUygunMu == true) {
                                  _wordService.addWord(controllerWord.text.trim(), controllerMean.text.trim());
                                  setState(() {
                                    statusText = "Last added word: ${controllerWord.text}";
                                    controllerWord.clear();
                                    controllerMean.clear();
                                    lastWordStatus = true;

                                    //focusu öncekine geri alir.
                                    FocusScope.of(context).previousFocus();
                                  });
                                }
                              },
                              child: const Text(
                                "Save New Word",
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 21, 45, 179),
                              ))),
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
