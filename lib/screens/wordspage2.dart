import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login_project/service/word_service.dart';
import 'package:firebase_login_project/utils/project_variables.dart';
import 'package:flutter/material.dart';

import '../widget/navigation_drawer_widget.dart';

class WordsPage extends StatefulWidget {
  WordsPage({Key? key}) : super(key: key);

  @override
  State<WordsPage> createState() => _WordsPageState();
}

bool meanVisible = false;
var valueVisibleList = List<bool>.filled(0, true, growable: true);

class _WordsPageState extends State<WordsPage> {
  final WordService _wordService = WordService();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            valueVisibleList.fillRange(0, valueVisibleList.length, !valueVisibleList[0]);
            setState(() {});
          }),
          backgroundColor: Colors.grey,
          child: const Icon(Icons.visibility),
        ),
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: ColorItems.mainColor,
          title: const Text('Word List Page'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _wordService.getWords(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
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
                                valueVisibleList[index] = !valueVisibleList[index];
                              });
                            },
                            onDoubleTap: () {
                              setState(() {
                                _showDeleteDialog(BuildContext);
                              });
                            },
                            child: Container(
                              constraints: BoxConstraints(minHeight: size * 4),
                              decoration: BoxDecoration(
                                  color: ColorItems.mainColor,
                                  border: Border.all(width: 5, color: Colors.grey),
                                  borderRadius: const BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: EdgeInsets.only(right: size, left: size),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${mypost['word']}",
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Text(
                                        ": ",
                                        style:
                                            TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: Visibility(
                                        visible: valueVisibleList[index],
                                        child: Text(
                                          "${mypost['mean']}",
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
            }));
  }
}
