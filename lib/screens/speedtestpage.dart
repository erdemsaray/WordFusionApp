import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login_project/service/word_service.dart';
import 'package:firebase_login_project/utils/project_variables.dart';
import 'package:flutter/material.dart';

class SpeedTestPage extends StatefulWidget {
  SpeedTestPage({Key? key}) : super(key: key);

  @override
  State<SpeedTestPage> createState() => _SpeedTestPageState();
}

int index = 0;
List<Alignment> alignment = [Alignment.bottomCenter, Alignment.bottomLeft, Alignment.bottomRight];
final WordService _wordService = WordService();
final Map<String, String> kelimeler = HashMap();

void indexDuzenle() {
  if (index < 2) {
    index++;
  } else {
    index = 0;
  }
}

class _SpeedTestPageState extends State<SpeedTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.dehaze),
        onPressed: () {
          print(kelimeler);
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _wordService.getWords(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              Future.delayed(Duration(seconds: 3)); //null dönüyor
            }
            for (int index = 0; index < 10; index++) {
              DocumentSnapshot mypost = snapshot.data!.docs[index];
              kelimeler.addAll({mypost['word']: mypost['mean']});
            }

            return !snapshot.hasData ? const Center(child: CircularProgressIndicator()) : Container(color: Colors.pink);
          }),
    );
  }
}
