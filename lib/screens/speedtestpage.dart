import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login_project/screens/testresultpage.dart';
import 'package:firebase_login_project/service/word_service.dart';
import 'package:flutter/material.dart';

import '../widget/navigation_drawer_widget.dart';

class SpeedTestPage extends StatefulWidget {
  const SpeedTestPage({Key? key}) : super(key: key);

  @override
  State<SpeedTestPage> createState() => _SpeedTestPageState();
}

Color cardColor = const Color.fromARGB(255, 40, 56, 146);

Timer? timer;
int kalanSure = 60;
int puan = 0;
int index = 0;
List<Alignment> alignment = [Alignment.bottomCenter, Alignment.bottomLeft, Alignment.bottomRight];
final WordService _wordService = WordService();
final Map<String, String> kelimeler = HashMap();
String questionWord = "asd";
List<String> cevaplar = [];
List<String> wrongWords = [];
RoundedRectangleBorder cardShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));
late Color scoreColor;
var boxdecoration = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color.fromARGB(255, 4, 42, 66), Colors.indigo],
        tileMode: TileMode.mirror));

void soruHazirla() {
  cevaplar.clear();

  if (kelimeler.length < 4) {
    questionWord = "4 words required!";
    cevaplar.add("not enough words");
    cevaplar.add("not enough words");
    cevaplar.add("not enough words");
    cevaplar.add("not enough words");
    timer!.cancel();
  } else {
    int x = Random().nextInt(kelimeler.length);

    questionWord = kelimeler.keys.elementAt(x);

    cevaplar.add(kelimeler.values.elementAt(x));

    for (int i = 0; i < 3; i++) {
      int y = Random().nextInt(kelimeler.values.length);
      cevaplar.add(kelimeler.values.elementAt(y));

      /*if (!cevaplar.contains(kelimeler.values.elementAt(y))) {
        
      } else {
        if (y + 1 != kelimeler.values.length) {
          cevaplar.add(kelimeler.values.elementAt(y + 1));
        } else {
          if (y - 1 != -1) {
            cevaplar.add(kelimeler.values.elementAt(y - 1));
          } else {
            cevaplar.add(kelimeler.values.elementAt(y));
          }
        }
      }*/
    }
    cevaplar.shuffle();
  }
}

class _SpeedTestPageState extends State<SpeedTestPage> {
  @override
  void initState() {
    scoreColor = Colors.green;
    kalanSure = 60;
    wrongWords.clear();
    startTimer();

    puan = 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Speed Test"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _wordService.getWords(),
          builder: (context, snapshot) {
            kelimeler.clear();
            if (!snapshot.hasData) {
              return const CircularProgressIndicator(); //null dönüyor
            } else {
              for (int index = 0; index < snapshot.data!.docs.length; index++) {
                DocumentSnapshot mypost = snapshot.data!.docs[index];
                kelimeler.addAll({mypost['word']: mypost['mean']});
              }
            }
            if (cevaplar.isEmpty) {
              soruHazirla();
            }
            return !snapshot.hasData
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.green.shade400,
                      Colors.blue.shade900,
                    ])),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: boxdecoration,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                          height: 70,
                                          child: Icon(
                                            Icons.star,
                                            size: 30,
                                            color: Colors.white,
                                          )),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Flexible(
                                        child: Text(
                                          questionWord,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: boxdecoration,
                                        height: 150,
                                        child: InkWell(
                                          onTap: () async {
                                            if (dogruMu(cevaplar[0])) {
                                              puan++;
                                              setState(() {});
                                            } else {
                                              wrongWords.add("$questionWord:  ${kelimeler[questionWord]}");
                                              puan--;
                                              setState(() {});
                                            }

                                            soruHazirla();
                                          },
                                          splashColor: Colors.blue,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 35),
                                                  child: Text(
                                                    cevaplar[0],
                                                    maxLines: 7,
                                                    style: const TextStyle(
                                                        fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: boxdecoration,
                                        height: 150,
                                        child: InkWell(
                                          onTap: () async {
                                            if (dogruMu(cevaplar[1])) {
                                              puan++;
                                              setState(() {});
                                            } else {
                                              wrongWords.add("$questionWord:  ${kelimeler[questionWord]}");
                                              puan--;
                                              setState(() {});
                                            }

                                            soruHazirla();
                                          },
                                          splashColor: Colors.blue,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                                  child: Text(
                                                    cevaplar[1],
                                                    maxLines: 7,
                                                    style: const TextStyle(
                                                        fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: boxdecoration,
                                        height: 150,
                                        child: InkWell(
                                          onTap: () async {
                                            if (dogruMu(cevaplar[2])) {
                                              puan++;
                                              setState(() {});
                                            } else {
                                              wrongWords.add("$questionWord:  ${kelimeler[questionWord]}");
                                              puan--;
                                              setState(() {});
                                            }

                                            soruHazirla();
                                          },
                                          splashColor: Colors.blue,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 35),
                                                  child: Text(
                                                    cevaplar[2],
                                                    maxLines: 7,
                                                    style: const TextStyle(
                                                        fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: boxdecoration,
                                        height: 150,
                                        child: InkWell(
                                          onTap: () async {
                                            if (dogruMu(cevaplar[3])) {
                                              puan++;
                                              setState(() {});
                                            } else {
                                              wrongWords.add("$questionWord:  ${kelimeler[questionWord]}");
                                              puan--;
                                              setState(() {});
                                            }

                                            soruHazirla();
                                          },
                                          splashColor: Colors.blue,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                                child: Text(
                                                  cevaplar[3],
                                                  maxLines: 7,
                                                  style: const TextStyle(
                                                      fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            DefaultTextStyle(
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Time: ${kalanSure}"),
                                  Text(
                                    "Score: ${puan}",
                                    style: TextStyle(color: scoreColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 110,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
          }),
    );
  }

  bool dogruMu(String cevaplar) {
    if (kelimeler[questionWord] == cevaplar) {
      scoreColor = Colors.green;
      return true;
    }

    scoreColor = Colors.red;
    return false;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (kalanSure < 1) {
            timer.cancel();

            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TestResultPage(kelimeler: wrongWords, point: puan),
              ),
            );
          } else {
            kalanSure--;
          }
        });
      }
    });
  }
}
