import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getUid() {
    return _auth.currentUser!.uid;
  }

  //匿名ログイン
  Future<void> signIn() async {
    await _auth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  bool isAuthenticated() {
    return _auth.currentUser != null;
  }
}
