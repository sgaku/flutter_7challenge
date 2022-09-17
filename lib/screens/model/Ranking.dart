import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_7challenge/Data/Data.dart';
import 'package:intl/intl.dart';

class Ranking extends ChangeNotifier {
  Ranking() {
    fetchRankingList();
  }

  List<Data>? list = [];

  Future<void> fetchRankingList() async {
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(now);

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ranking')
        .doc(date)
        .collection('ranking')
        .orderBy('time')
        .limit(100)
        .get();

    final List<Data> list = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String time = data['time'];
      final String user = data['user'];
      return Data(time, user);
    }).toList();

    this.list = list;
    notifyListeners();
  }
}
