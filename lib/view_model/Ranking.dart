import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_7challenge/Data/local/user.dart';
import 'package:flutter_7challenge/common/format_for_now.dart';

class Ranking extends ChangeNotifier {
  List<User>? list = [];

  Future<void> fetchRankingList() async {
    var date = formatForNow();
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ranking')
        .doc(date)
        .collection('ranking')
        .orderBy('time')
        .limit(100)
        .get();

    final List<User> list = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String time = data['time'];
      final String user = data['user'];
      return User(time, user);
    }).toList();

    this.list = list;
    notifyListeners();
  }
}
