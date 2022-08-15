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
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.dehaze),
        onPressed: () async {
          await Future.delayed(const Duration(milliseconds: 700));
          yeniSoruyaGec();
        },
      ),
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

            Color card0Color = Colors.white;
            Color card1Color = Colors.white;
            Color card2Color = Colors.white;
            Color card3Color = Colors.white;

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
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 40,
                                  ),
                                  child: Card(
                                    child: InkWell(
                                      onTap: () {},
                                      splashColor: Colors.blue,
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
                                                setState(() {});
                                                await Future.delayed(const Duration(milliseconds: 700));
                                                yeniSoruyaGec();
                                              } else {
                                                card0Color = Colors.red;
                                                setState(() {});
                                              }
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
                                                setState(() {});
                                                await Future.delayed(const Duration(milliseconds: 700));
                                                yeniSoruyaGec();
                                              } else {
                                                card1Color = Colors.red;
                                                setState(() {});
                                              }
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
                                                setState(() {});
                                                await Future.delayed(const Duration(milliseconds: 700));
                                                yeniSoruyaGec();
                                              } else {
                                                card2Color = Colors.red;
                                                setState(() {});
                                              }
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
                                                setState(() {});
                                                await Future.delayed(const Duration(milliseconds: 700));
                                                yeniSoruyaGec();
                                              } else {
                                                card3Color = Colors.red;
                                                setState(() {});
                                              }
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
    card3answer = false;
    card2answer = false;
    card1answer = false;
    card0answer = false;
    soruHazirla();
    setState(() {});
  }
}
