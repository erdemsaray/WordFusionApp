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

class _WordsPageState extends State<WordsPage> {
  final WordService _wordService = WordService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot mypost = snapshot.data!.docs[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              if (mypost['word'] == mypost['mean']) {
                                print("esit");
                              } else {
                                print("degil");
                              }
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [Text("${mypost['word']}"), Text("${mypost['mean']}")],
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
