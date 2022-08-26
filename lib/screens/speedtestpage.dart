import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login_project/service/word_service.dart';
import 'package:firebase_login_project/utils/project_variables.dart';
import 'package:flutter/material.dart';

import '../widget/navigation_drawer_widget.dart';

class SpeedTestPage extends StatefulWidget {
  SpeedTestPage({Key? key}) : super(key: key);

  @override
  State<SpeedTestPage> createState() => _SpeedTestPageState();
}

Color card0Color = Colors.white;
Color card1Color = Colors.white;
Color card2Color = Colors.white;
Color card3Color = Colors.white;

Timer? timer;
int kalanSure = 60;
int puan = 0;
int index = 0;
List<Alignment> alignment = [Alignment.bottomCenter, Alignment.bottomLeft, Alignment.bottomRight];
final WordService _wordService = WordService();
final Map<String, String> kelimeler = HashMap();
String questionWord = "asd";
List<String> cevaplar = [];
bool card3answer = false;
bool card2answer = false;
bool card1answer = false;
bool card0answer = false;

void soruHazirla() {
  cevaplar.clear();

  if (kelimeler.length < 4) {
    questionWord = "yeterli kelime yok";
    cevaplar.add("yeterli kelime yok");
    cevaplar.add("yeterli kelime yok");
    cevaplar.add("yeterli kelime yok");
    cevaplar.add("yeterli kelime yok");
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
  int gecikmeSuresi = 300;

  @override
  void initState() {
    startTimer();
    kalanSure = 60;
    puan = 0;
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: ColorItems.mainColor,
        title: const Text('Speed Test Page'),
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
                        Container(
                          height: size.height * 3,
                          decoration: const BoxDecoration(
                              //image: DecorationImage(alignment: Alignment.topCenter, image: AssetImage('assets/topheader.png'
                              //)
                              //)
                              ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 40,
                                  ),
                                  child: Card(
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.accessibility, size: 70.0),
                                              const SizedBox(
                                                width: 70,
                                              ),
                                              Text(
                                                questionWord,
                                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                                    padding: const EdgeInsets.only(right: 10, left: 10, bottom: 40),
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
                                                puan--;
                                                setState(() {});
                                              }

                                              await Future.delayed(Duration(milliseconds: gecikmeSuresi));
                                              yeniSoruyaGec();
                                            },
                                            splashColor: Colors.blue,
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    cevaplar[0],
                                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
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
                                                puan--;
                                                setState(() {});
                                              }
                                              await Future.delayed(Duration(milliseconds: gecikmeSuresi));
                                              yeniSoruyaGec();
                                            },
                                            splashColor: Colors.blue,
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    cevaplar[1],
                                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                                                puan--;
                                                setState(() {});
                                              }
                                              await Future.delayed(Duration(milliseconds: gecikmeSuresi));
                                              yeniSoruyaGec();
                                            },
                                            splashColor: Colors.blue,
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    cevaplar[2],
                                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                                                puan--;
                                                setState(() {});
                                              }

                                              await Future.delayed(Duration(milliseconds: gecikmeSuresi));
                                              yeniSoruyaGec();
                                            },
                                            splashColor: Colors.blue,
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    cevaplar[3],
                                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 50, right: 20, left: 20),
                                  child: DefaultTextStyle(
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    child: Row(
                                      children: [
                                        Text("Puan: ${puan}"),
                                        const Expanded(
                                          child: SizedBox(
                                            width: 120,
                                          ),
                                        ),
                                        Text("Kalan Süre: ${kalanSure}"),
                                      ],
                                    ),
                                  ),
                                ),
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
    card0Color = Colors.white;
    card1Color = Colors.white;
    card2Color = Colors.white;
    card3Color = Colors.white;
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
      setState(() {
        if (kalanSure < 1) {
          timer.cancel();
          Navigator.pop(context);
        } else {
          kalanSure--;
        }
      });
    });
  }
}
