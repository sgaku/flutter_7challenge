import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchUserNameProvider = Provider((ref) => FetchUserName());

class FetchUserName {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> fetchUser() async {
    final uid = _auth.currentUser!.uid;
    DocumentSnapshot snapshot =
        await _fireStore.collection('user').doc(uid).get();
    return snapshot.get('name');
  }

}
