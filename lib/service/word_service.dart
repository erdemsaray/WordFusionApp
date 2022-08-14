import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_project/model/word_model.dart';

class WordService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String userWordListKey = "User: ${FirebaseAuth.instance.currentUser!.uid}";

  Future<WordModel?> addWord(String word, String mean) async {
    try {
      var ref = _fireStore.collection(userWordListKey);

      var documentRef = await ref.add({'word': word, 'mean': mean});
      return WordModel(id: documentRef.id, word: word, mean: mean);
    } catch (e) {
      return null;
    }
  }

  Stream<QuerySnapshot> getWords() {
    var ref = _fireStore.collection(userWordListKey).snapshots();

    return ref;
  }

  List getWordList() {
    var ref = _fireStore.collection(userWordListKey).snapshots();
    return [2, 3];
  }

  Future<void> removeWord(String docId) {
    var ref = _fireStore.collection(userWordListKey).doc(docId).delete();

    return ref;
  }
}
