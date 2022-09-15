import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepositoryProvider = Provider((_ref) => AuthRepository());

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUid() async {
    return _auth.currentUser!.uid;
  }

  //匿名ログイン
  Future<void> signIn() async {
    await _auth.signInAnonymously();
  }
}