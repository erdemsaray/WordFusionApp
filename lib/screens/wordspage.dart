import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login_project/service/word_service.dart';
import 'package:flutter/material.dart';
import '../widget/navigation_drawer_widget.dart';

class WordsPage extends StatefulWidget {
  WordsPage({Key? key}) : super(key: key);

  @override
  State<WordsPage> createState() => _WordsPageState();
}

bool isMemoryButtonClicked = false;
bool isChangeButtonClicked = false;
bool meanVisible = false;
bool rightOrLeft = true;
var valueVisibleList = List<bool>.filled(0, true, growable: true);
var valueVisibleList2 = List<bool>.filled(1, true, growable: true);

class _WordsPageState extends State<WordsPage> {
  final WordService _wordService = WordService();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.05;
    String boxFirst = "word";
    String boxSecond = "mean";

    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green.shade600,
          onPressed: (() {
            visibilityChange(rightOrLeft);
            setState(() {});
          }),
          child: const Icon(Icons.visibility),
        ),
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: isMemoryButtonClicked
                      ? MaterialStateProperty.all(Colors.green.shade600)
                      : MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                isMemoryButtonClicked = !isMemoryButtonClicked;
                setState(() {});
              },
              child: Icon(Icons.save_alt),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 2),
              child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: !rightOrLeft
                          ? MaterialStateProperty.all(Colors.green.shade600)
                          : MaterialStateProperty.all(Colors.transparent)),
                  onPressed: () {
                    visibleEvery();
                    rightOrLeft = !rightOrLeft;
                    setState(() {});
                  },
                  child: const Icon(Icons.autorenew_rounded)),
            )
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: AnimatedTextKit(
            animatedTexts: [WavyAnimatedText("Words")],
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.green.shade400,
            Colors.blue.shade900,
          ])),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: _wordService.getWords(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              valueVisibleList2.add(true);
                              valueVisibleList.add(false);
                              DocumentSnapshot mypost = snapshot.data!.docs[index];

                              Future<void> _showDeleteDialog(BuildContext) {
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Center(child: Text("Kelime silinsin mi?")),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        content: Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  onTap: () => _wordService
                                                      .removeWord(mypost.id)
                                                      .then((value) => Navigator.pop(context)),
                                                  child: const Text("Evet")),
                                              const SizedBox(
                                                width: 40,
                                              ),
                                              InkWell(onTap: () => Navigator.pop(context), child: const Text("Hayır"))
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }

                              return Padding(
                                padding: EdgeInsets.all(size * 0.2),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      visibleIndex(index, rightOrLeft, mypost.id);
                                    });
                                  },
                                  onDoubleTap: () {
                                    if (!isMemoryButtonClicked) {
                                      setState(() {
                                        _showDeleteDialog(BuildContext);
                                      });
                                    }
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(minHeight: size * 4),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(25), right: Radius.circular(25)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [Color.fromARGB(255, 4, 42, 66), Colors.indigo],
                                            tileMode: TileMode.mirror)),
                                    child: Padding(
                                      padding: EdgeInsets.only(right: size, left: size),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Visibility(
                                                visible: valueVisibleList2[index],
                                                child: Text(
                                                  "${mypost[boxFirst]}",
                                                  style: const TextStyle(
                                                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              ": ",
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                child: Visibility(
                                              visible: valueVisibleList[index],
                                              child: Text(
                                                "${mypost[boxSecond]}",
                                                style: const TextStyle(
                                                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  }),
            ),
          ),
        ));
  }

  void visibilityChange(bool value) {
    if (value) {
      valueVisibleList.fillRange(0, valueVisibleList.length, !valueVisibleList[0]);
    } else {
      valueVisibleList2.fillRange(0, valueVisibleList2.length, !valueVisibleList2[0]);
    }
  }

  void visibleEvery() {
    valueVisibleList.fillRange(0, valueVisibleList.length, true);
    valueVisibleList2.fillRange(0, valueVisibleList2.length, true);
  }

  void visibleIndex(int index, bool value, String id) {
    if (isMemoryButtonClicked) {
      _wordService.addInMemory(id);
    } else {
      if (value) {
        valueVisibleList[index] = !valueVisibleList[index];
      } else {
        valueVisibleList2[index] = !valueVisibleList2[index];
      }
    }
  }

  List getVariables() {
    Stream<QuerySnapshot<Object?>> snapshot = _wordService.getWords();
    print(snapshot.first);

    return [2, 4];
  }
}
