import 'package:flutter/material.dart';
import 'package:flutter_7challenge/main.dart';
import 'package:flutter_7challenge/screens/launch/registration_screen.dart';
import 'package:flutter_7challenge/screens/page/RankingPage.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_7challenge/Data/firestore/AuthRepository.dart';

final stateProvider = StateProvider((ref) {
  return "";
});

class RecordPage extends ConsumerStatefulWidget {
  const RecordPage({super.key});

  @override
  RecordPageState createState() => RecordPageState();
}

class RecordPageState extends ConsumerState<RecordPage> {
  String onPressedTime = '';
  bool isRecorded = false;

  // String name = '';
  var _timer;

  @override
  void initState() {
    super.initState();

    /// Timer.periodic は繰り返し実行する時に使うメソッド
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimer);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    final username = ref.watch(userProvider);
    final time = ref.watch(stateProvider);
    final value = ref.watch(rankingProvider);
    final auth = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('記録ページ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  await auth.signOut();
                },
                child: const Text("ログアウト")),
            Text(
              time,
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              onPressed: now.hour < 16 || now.hour > 21 || isRecorded
                  ? null
                  : () async {
                      onPressedTime = time;
                      isRecorded = true;
                      await addData();
                      await value.fetchRankingList();
                      final list = value.list ?? [];
                      final rank = list.indexWhere((element) {
                        return element.time == onPressedTime;
                      });
                      ScaffoldMessengerState scaffoldMessengerState =
                          scaffoldKey.currentState!;
                      scaffoldMessengerState.showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('あなたの順位は${rank + 1}位です'),
                        ),
                      );
                    },
              child: const Text('記録する'),
            ),
            Text(
              onPressedTime,
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  void _onTimer(Timer timer) {
    final timerStateController = ref.read(stateProvider.notifier);

    /// 現在時刻を取得する
    var now = DateTime.now();

    /// 「時:分:秒」表記に文字列を変換するdateFormatを宣言する
    var dateFormat = DateFormat('HH:mm:ss');

    /// nowをdateFormatでstringに変換する
    var timeString = dateFormat.format(now);
    timerStateController.state = timeString;
  }

  Future addData() async {
    final uid = ref.read(authRepositoryProvider).getUid();
    final snapshot =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    final name = snapshot.get('name');

    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(now);

    await FirebaseFirestore.instance
        .collection('ranking')
        .doc(date)
        .collection('ranking')
        .add({
      'time': onPressedTime,
      'user': name,
    });
  }
}
