import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/format_for_now.dart';

final checkUserProvider = Provider((ref) => CheckUserRecord(ref));

class CheckUserRecord {
  CheckUserRecord(this.ref);

  final Ref ref;

  ///ユーザーが既に記録しているかどうかを確認する
  Future<bool> isUserAlreadyRecorded() async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;

    var date = formatForNow();

    final id = await FirebaseFirestore.instance
        .collection('ranking')
        .doc(date)
        .collection('ranking')
        .where('uid', isEqualTo: uid)
        .get();

    return id.docs.isEmpty ? false : true;
  }
}
