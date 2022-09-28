import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../utils/project_variables.dart';
import '../widget/navigation_drawer_widget.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key}) : super(key: key);

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

String translated = "Translation";
final languageItems = ['English (EN)', 'Turkish (TR)'];

Map languageWithCode = {
  'English (EN)': 'en',
  'Turkish (TR)': 'tr',
};

class _TranslatePageState extends State<TranslatePage> {
  TextEditingController enterTextController = TextEditingController();

  String? value = 'English (EN)';
  String? value2 = 'Turkish (TR)';
  String fromInput = 'en';
  String toInput = 'tr';

  @override
  void initState() {
    translated = "Translation";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightSize = MediaQuery.of(context).size.height;
    double widthSize = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorItems.mainColor,
          onPressed: () {},
          child: const Icon(
            Icons.add,
          ),
        ),
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: ColorItems.mainColor,
          title: const Text('Translate Page'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            height: widthSize * 1.40,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.white, fontSize: 24),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: heightSize * 0.03, top: 30, bottom: heightSize * 0.01),
                      child: SizedBox(
                        child: Image.asset('assets/translateimage.png'),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: const TextStyle(
                          fontSize: 24,
                          color: ColorItems.translateBlue,
                        ),
                        value: value,
                        items: languageItems.map(buildMenuItem).toList(),
                        onChanged: (value) => setState(() => this.value = value),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold, color: ColorItems.translateBlue),
                            decoration:
                                const InputDecoration(hintText: "Enter text", hintStyle: TextStyle(color: Colors.grey)),
                            onChanged: (text) async {
                              if (text.isNotEmpty && text.characters.first != ' ') {
                                final translation = await text
                                    .translate(
                                  from: languageWithCode[value],
                                  to: languageWithCode[value2],
                                )
                                    .then((value) {
                                  if (text.isNotEmpty) {
                                    translated = value.text;
                                  } else {
                                    translated = 'Translation';
                                  }

                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                              } else {
                                translated = 'Translation';
                                if (mounted) {
                                  setState(() {});
                                }
                              }
                            },
                          ),
                        ),
                        IconButton(
                            color: Color.fromARGB(255, 165, 164, 164),
                            onPressed: () {
                              String? temp = value;
                              value = value2;
                              value2 = temp;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.change_circle_outlined,
                              size: 45,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: const TextStyle(
                          fontSize: 24,
                          color: ColorItems.translateBlue,
                        ),
                        value: value2,
                        items: languageItems.map(buildMenuItem).toList(),
                        onChanged: (value) => setState(() => value2 = value),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      translated,
                      style:
                          const TextStyle(color: ColorItems.translateBlue, fontWeight: FontWeight.bold, fontSize: 36),
                    ),
                    const Divider(
                      height: 20,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );
}
