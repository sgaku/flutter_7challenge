import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_7challenge/screens/launch/registration_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userUniqueRepositoryProvider =
    Provider((ref) => UserUniqueRepository(ref));

class UserUniqueRepository {
  UserUniqueRepository(this.ref);

  final Ref ref;

  Future<bool> isUniqueUser({required String name}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('name', isEqualTo: name)
        .get();
    return snapshot.docs.isEmpty ? true : false;
  }
}
