import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("SONUC: ${user.user}");
      return user.user;
    } catch (e) {
      return null;
    }
  }

  signOut() async {
    return await _auth.signOut();
  }

  void passwordReset(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential?> signWithGmailAccount() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> createPerson(String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    await _firestore.collection("Person").doc(user.user?.uid).set({'email': email, 'password': password});

    return user.user;
  }
}
