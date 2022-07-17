import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login_project/model/word_model.dart';

class WordService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<WordModel?> addWord(String word, String mean) async {
    try {
      var ref = _fireStore.collection("Words");

      var documentRef = await ref.add({'word': word, 'mean': mean});
      return WordModel(id: documentRef.id, word: word, mean: mean);
    } catch (e) {
      return null;
    }
  }

  Stream<QuerySnapshot> getWords() {
    var ref = _fireStore.collection("Words").snapshots();
    return ref;
  }

  Future<void> removeWord(String docId) {
    var ref = _fireStore.collection("Words").doc(docId).delete();

    return ref;
  }
}
