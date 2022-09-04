import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_7challenge/Data.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Data> list = [];
  final Stream<QuerySnapshot> _rankingStream =
      FirebaseFirestore.instance.collection('ranking').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング画面'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _rankingStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            final List<Data> data =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              final String time = data['time'];
              final String user = data['user'];
              return Data(time, user);
            }).toList();
            list = data;

            return ListView.separated(
              itemBuilder: (context, index) => ListTile(
                leading: ExcludeSemantics(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(list[index].user),
                subtitle: Text(list[index].time),
              ),
              separatorBuilder: (context, index) {
                return const Divider(height: 0.5);
              },
              itemCount: list.length,
            );
          },
        ),
      ),
    );
  }
}
