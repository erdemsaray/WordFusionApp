import 'package:firebase_login_project/service/word_service.dart';
import 'package:firebase_login_project/utils/project_variables.dart';
import 'package:firebase_login_project/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: secondColor,
        title: const Text('Awesome Words'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(right: 40, left: 40),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 60),
            children: [
              Image.asset('assets/anewword.png'),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: TextFormField(
                  controller: controllerWord,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Word',
                    contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
              ),
              TextFormField(
                controller: controllerMean,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Mean',
                  contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                  visible: lastWordStatus,
                  child: Text(
                    statusText,
                    style: const TextStyle(color: Colors.green),
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
                                _wordService.addWord(controllerWord.text, controllerMean.text).then((value) {
                                  statusText = "Son eklenen kelime: ${value!.word}";
                                  controllerWord.clear();
                                  controllerMean.clear();
                                });
                                lastWordStatus = true;
                                setState(() {});
                              },
                              child: const Text(
                                "Save New Word",
                              ),
                              style: ElevatedButton.styleFrom(primary: secondColor)))),
                ],
              ),
              const SizedBox(
                height: 35,
              )
            ],
          ),
        ),
      ),
    );
  }
}
