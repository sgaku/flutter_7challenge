

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_7challenge/Data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Ranking extends ChangeNotifier {
  Ranking() {
    fetchRankingList();
  }

  List<Data>? list = [];
 Future<void> fetchRankingList() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ranking')
        .orderBy('time')
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

final rankingProvider = ChangeNotifierProvider((ref) {
  return Ranking();
});

class RankingPage extends ConsumerWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(rankingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング画面'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          leading: ExcludeSemantics(
            child: Text(
              '${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(value.list![index].user),
          subtitle: Text(value.list![index].time),
        ),
        separatorBuilder: (context, index) {
          return const Divider(height: 0.5);
        },
        itemCount: value.list!.length,
      ),
    );
  }
}
