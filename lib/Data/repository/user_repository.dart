import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/method/format_for_now.dart';

final userProvider = Provider((ref) => UserRepository());

class UserRepository {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  ///ユーザーが既に記録しているかどうかを確認する
  Future<bool> isUserAlreadyRecorded() async {
    final uid = _auth.currentUser!.uid;

    var date = formatForNow();

    final id = await _fireStore
        .collection('ranking')
        .doc(date)
        .collection('ranking')
        .where('uid', isEqualTo: uid)
        .get();

    return id.docs.isEmpty ? false : true;
  }

  ///ユーザーネームがユニークかどうかを確認する
  Future<bool> isUniqueUser({required String name}) async {
    final snapshot = await _fireStore
        .collection('user')
        .where('name', isEqualTo: name)
        .get();
    return snapshot.docs.isEmpty ? true : false;
  }

  ///ユーザーネームを返す
  Future<String> fetchUser() async {
    final uid = _auth.currentUser!.uid;
    DocumentSnapshot snapshot =
        await _fireStore.collection('user').doc(uid).get();
    return snapshot.get('name');
  }
}
