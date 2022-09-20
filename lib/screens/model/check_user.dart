
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_7challenge/screens/model/fetch_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final checkUserProvider = Provider((ref) => CheckUser(ref));

class CheckUser{
  CheckUser(this.ref);
  final Ref ref;

  Future<bool> checkUserDocs() async {
    final username = await ref.read(fetchUserProvider).fetchUser();
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(now);

    final user = await FirebaseFirestore.instance
        .collection('ranking')
        .doc(date)
        .collection('ranking')
        .where('user', isEqualTo: username)
        .get();

    return user.docs.isEmpty ? false : true;
  }

}