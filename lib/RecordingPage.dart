import 'package:flutter/material.dart';
import 'package:flutter_7challenge/main.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  String name = '';
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
    final time = ref.watch(stateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('記録ページ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(hintText: '名前を入力してね'),
                onChanged: (text) {
                  name = text;
                },
              ),
            ),
            Text(
              time,
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              onPressed: () async {
                onPressedTime = time;
                try {
                  await addData();
                  ScaffoldMessengerState scaffoldMessengerState =
                      scaffoldKey.currentState!;
                  scaffoldMessengerState.showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('記録されました！'),
                    ),
                  );
                } catch (e) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
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
    final time = ref.watch(stateProvider);
    if (name == "") {
      throw 'ユーザーネームが登録されていません';
    }
    await FirebaseFirestore.instance.collection('ranking').add({
      'time': time,
      'user': name,
    });
  }
}

