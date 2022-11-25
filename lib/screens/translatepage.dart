import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../utils/project_variables.dart';
import '../widget/navigation_drawer_widget.dart';
import 'package:firebase_login_project/service/word_service.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key}) : super(key: key);

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

String enterText = "Enter Text";
String translatedValue = "Translation";
bool emptyControl = false;

final languageItems = [
  'English (EN)',
  'Turkish (TR)',
  'Russian (RU)',
  'German (DE)',
  'Chinese (ZH)',
  'French (FR)',
  'Spanish (ES)'
];

//'fr': 'French',
//'es': 'Spanish',

Map languageWithCode = {
  'English (EN)': 'en',
  'Turkish (TR)': 'tr',
  'Russian (RU)': 'ru',
  'German (DE)': 'de',
  'Chinese (ZH)': 'zh-cn',
  'French (FR)': 'fr',
  'Spanish (ES)': 'es'
};

class _TranslatePageState extends State<TranslatePage> {
  TextEditingController enterTextController = TextEditingController();
  TextEditingController translatedTextController = TextEditingController();

  final _wordService = WordService();

  String? value = 'English (EN)';
  String? value2 = 'Turkish (TR)';
  String fromInput = 'en';
  String toInput = 'tr';
  String attentionText = "Word can't be empty";
  Color attentionTextColor = Colors.red;

  @override
  void initState() {
    translatedTextController.text = "Translation";
    emptyControl = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
        //resize avoid --> çeviri klavyenin altına geçecek kadar uzun oldugunda
        //overflow hatası vermemesini, nesnelerin klavyenin altına girmesini sağlıyor.
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: AnimatedTextKit(
            animatedTexts: [WavyAnimatedText("Translate")],
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                      child: ListView(
                        shrinkWrap: true,
                        reverse: false,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: heightSize * 0.02,
                              right: heightSize * 0.05,
                            ),
                            child: SizedBox(
                              child: Image.asset('assets/translateimage.png'),
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: ColorItems.dropdownColor,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
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
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  controller: enterTextController,
                                  style: const TextStyle(
                                      fontSize: 36, fontWeight: FontWeight.bold, color: ColorItems.translateBlue),
                                  decoration: const InputDecoration(
                                      hintText: "Enter text", hintStyle: TextStyle(color: Colors.white60)),
                                  onChanged: (text) async {
                                    enterText = text;

                                    if (text.isNotEmpty && text.characters.first != ' ') {
                                      final translation = await text
                                          .translate(
                                        from: languageWithCode[value],
                                        to: languageWithCode[value2],
                                      )
                                          .then((value) {
                                        if (text.isNotEmpty) {
                                          translatedValue = value.text;
                                        } else {
                                          translatedValue = 'Translation';
                                        }

                                        if (mounted) {
                                          setState(() {});
                                        }
                                      });
                                    } else {
                                      translatedValue = 'Translation';
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    }

                                    if (mounted) {
                                      setState(() {
                                        translatedTextController.text = translatedValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                  color: Colors.white70,
                                  onPressed: () {
                                    String? temp = value;
                                    value = value2;
                                    value2 = temp;
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.change_circle_outlined,
                                    size: 45,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 24,
                            child: Visibility(
                              visible: emptyControl,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  attentionText,
                                  style:
                                      TextStyle(color: attentionTextColor, fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: ColorItems.dropdownColor,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                              value: value2,
                              items: languageItems.map(buildMenuItem).toList(),
                              onChanged: (value) => setState(() => value2 = value),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  controller: translatedTextController,
                                  style: const TextStyle(
                                      color: ColorItems.translateBlue, fontWeight: FontWeight.bold, fontSize: 36),
                                ),
                              ),
                              IconButton(
                                  color: Colors.white70,
                                  onPressed: () {
                                    kelimeEkle();
                                  },
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    size: 45,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );

  void kelimeEkle() {
    setState(() {
      if (enterTextController.text.isEmpty) {
        attentionTextColor = Colors.red;
        attentionText = "Word can't be empty";
        emptyControl = true;
      } else {
        _wordService.addWord(enterText, translatedTextController.text);
        attentionTextColor = Colors.yellow;
        attentionText = 'Last added: $enterText';
        emptyControl = true;
        enterTextController.clear();
      }
    });
  }
}
