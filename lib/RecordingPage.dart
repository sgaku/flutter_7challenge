import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => RecordPageState();
}

class RecordPageState extends State<RecordPage> {
  /// タイマー文字列用
  String _time = '';
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
              _time,
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                onPressedTime = _time;
                addData();
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
    /// 現在時刻を取得する
    var now = DateTime.now();

    /// 「時:分:秒」表記に文字列を変換するdateFormatを宣言する
    var dateFormat = DateFormat('HH:mm:ss');

    /// nowをdateFormatでstringに変換する
    var timeString = dateFormat.format(now);
    if (mounted) {
      setState(() => {_time = timeString});
    }
  }

  Future addData() async {
    await FirebaseFirestore.instance.collection('ranking').add({
      'time': _time,
      'user': name,
    });
  }
}
