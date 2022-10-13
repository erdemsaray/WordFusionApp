import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
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

Color card0Color = Colors.indigo;
Color card1Color = Colors.indigo;
Color card2Color = Colors.indigo;
Color card3Color = Colors.indigo;

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
bool card3answer = false;
bool card2answer = false;
bool card1answer = false;
bool card0answer = false;

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
    //bu kısımda hata veriyor
    int x = Random().nextInt(kelimeler.length - 1);

    questionWord = kelimeler.keys.elementAt(x);

    cevaplar.add(kelimeler.values.elementAt(x));

    for (int i = 0; i < 3; i++) {
      int y = Random().nextInt(kelimeler.values.length - 1);
      if (!cevaplar.contains(kelimeler.values.elementAt(y))) {
        cevaplar.add(kelimeler.values.elementAt(y));
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
      }
    }
    cevaplar.shuffle();
  }
}

class _SpeedTestPageState extends State<SpeedTestPage> {
  int gecikmeSuresi = 200;

  @override
  void initState() {
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
        title: AnimatedTextKit(
          animatedTexts: [WavyAnimatedText("Speed Test")],
          repeatForever: false,
        ),
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

              if (cevaplar.isEmpty) {
                soruHazirla();
              }
            }

            return !snapshot.hasData
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.green.shade400,
                      Colors.blue.shade900,
                    ])),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: size.height * 3,
                            decoration: const BoxDecoration(
                                //image: DecorationImage(alignment: Alignment.topCenter, image: AssetImage('assets/topheader.png'
                                //)
                                //)
                                ),
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 40,
                                  ),
                                  child: Card(
                                    color: Colors.indigo,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
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
                                              Text(
                                                questionWord,
                                                style: const TextStyle(
                                                    fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                    ),
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      children: [
                                        Card(
                                          color: card0answer ? Colors.green : card0Color,
                                          child: InkWell(
                                            onTap: () async {
                                              card0answer = dogruMu(cevaplar[0]);
                                              if (card0answer == true) {
                                                puan++;
                                                setState(() {});
                                              } else {
                                                card0Color = Colors.red;
                                                wrongWords.add("$questionWord => ${kelimeler[questionWord]}");
                                                puan--;
                                                setState(() {});
                                              }

                                              await Future.delayed(Duration(milliseconds: gecikmeSuresi));
                                              yeniSoruyaGec();
                                            },
                                            splashColor: Colors.blue,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 35),
                                                      child: Text(
                                                        cevaplar[0],
                                                        style: const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: card1answer ? Colors.green : card1Color,
                                          child: InkWell(
                                            onTap: () async {
                                              card1answer = dogruMu(cevaplar[1]);
                                              if (card1answer == true) {
                                                puan++;
                                                setState(() {});
                                              } else {
                                                card1Color = Colors.red;
                                                wrongWords.add("$questionWord => ${kelimeler[questionWord]}");
                                                puan--;
                                                setState(() {});
                                              }
                                              await Future.delayed(Duration(milliseconds: gecikmeSuresi));
                                              yeniSoruyaGec();
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
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: card2answer ? Colors.green : card2Color,
                                          child: InkWell(
                                            onTap: () async {
                                              card2answer = dogruMu(cevaplar[2]);
                                              if (card2answer == true) {
                                                puan++;
                                                setState(() {});
                                              } else {
                                                card2Color = Colors.red;
                                                wrongWords.add("$questionWord => ${kelimeler[questionWord]}");
                                                puan--;
                                                setState(() {});
                                              }
                                              await Future.delayed(Duration(milliseconds: gecikmeSuresi));
                                              yeniSoruyaGec();
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
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: card3answer ? Colors.green : card3Color,
                                          child: InkWell(
                                            onTap: () async {
                                              card3answer = dogruMu(cevaplar[3]);
                                              if (card3answer == true) {
                                                puan++;
                                                setState(() {});
                                              } else {
                                                card3Color = Colors.red;
                                                wrongWords.add("$questionWord => ${kelimeler[questionWord]}");
                                                puan--;
                                                setState(() {});
                                              }

                                              await Future.delayed(Duration(milliseconds: gecikmeSuresi));
                                              yeniSoruyaGec();
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
                                                    style: const TextStyle(
                                                        fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DefaultTextStyle(
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Score: ${puan}"),
                                      Text("Time: ${kalanSure}"),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 110,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
          }),
    );
  }

  bool dogruMu(String cevaplar) {
    if (kelimeler[questionWord] == cevaplar) {
      return true;
    }

    return false;
  }

  void yeniSoruyaGec() {
    card0Color = Colors.indigo;
    card1Color = Colors.indigo;
    card2Color = Colors.indigo;
    card3Color = Colors.indigo;
    card3answer = false;
    card2answer = false;
    card1answer = false;
    card0answer = false;
    soruHazirla();
    setState(() {});
  }

  bool yanlisVarMi() {
    if (card0Color == Colors.red || card1Color == Colors.red || card2Color == Colors.red || card3Color == Colors.red) {
      return true;
    } else {
      return false;
    }
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
