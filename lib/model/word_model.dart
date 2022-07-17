import 'package:cloud_firestore/cloud_firestore.dart';

class WordModel {
  String id;
  String word;
  String mean;

  WordModel({required this.id, required this.word, required this.mean});

  factory WordModel.fromSnapshot(DocumentSnapshot snapshot) {
    return WordModel(
      id: snapshot.id,
      word: snapshot["word"],
      mean: snapshot["mean"],
    );
  }
}
