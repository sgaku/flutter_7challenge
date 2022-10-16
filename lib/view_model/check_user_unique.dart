import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkUserUniqueProvider =
    Provider((ref) => CheckUserUnique(ref));

class CheckUserUnique {
  CheckUserUnique(this.ref);

  final Ref ref;

  Future<bool> isUniqueUser({required String name}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('name', isEqualTo: name)
        .get();
    return snapshot.docs.isEmpty ? true : false;
  }
}
