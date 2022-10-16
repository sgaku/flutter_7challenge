import 'package:flutter/material.dart';
import 'package:flutter_7challenge/main.dart';
import 'package:flutter_7challenge/screens/view_model/check_user.dart';
import 'package:flutter_7challenge/screens/view_model/fetch_user.dart';

import 'package:flutter_7challenge/screens/view/RankingPage.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_7challenge/Data/firestore/AuthRepository.dart';
import 'package:analog_clock/analog_clock.dart';

final stateProvider = StateProvider((ref) {
  return "";
});

final checkUserBoolProvider = StateProvider((ref) {
  return false;
});

class RecordPage extends ConsumerStatefulWidget {
  const RecordPage({super.key});

  @override
  RecordPageState createState() => RecordPageState();
}

class RecordPageState extends ConsumerState<RecordPage> {
  String onPressedTime = '';
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
    final time = ref.watch(stateProvider);
    final isRecorded = ref.watch(checkUserBoolProvider);
    final value = ref.watch(rankingProvider);
    // final auth = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '今日のチャレンジ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isRecorded  ||  now.hour <= 6 || now.hour >= 8
          ? isRecorded
              ? Center(
                  child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("今日のチャレンジは終わりました"),
                  content: const Text("今日の記録が既に存在します。また明日チャレンジしましょう"),
                ))
              : Center(
                  child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("今日のチャレンジは終わりました"),
                  content: const Text("AM7:00-8:00を過ぎました。また明日チャレンジしましょう"),
                ))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AnalogClock(
                      height: 300,
                      width: 300,
                      showDigitalClock: false,
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () async {
                  //       await auth.signOut();
                  //     },
                  //     child: const Text("ログアウト")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      time,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: isRecorded
                        ? null
                        : () async {
                            onPressedTime = time;
                            await addData();
                            final isRecordedController =
                                ref.read(checkUserBoolProvider.notifier);
                            isRecordedController.state = await ref
                                .read(checkUserProvider)
                                .checkUserDocs();
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
    final username = await ref.read(fetchUserProvider).fetchUser();

    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(now);

    await FirebaseFirestore.instance
        .collection('ranking')
        .doc(date)
        .collection('ranking')
        .add({
      'time': onPressedTime,
      'user': username,
    });
  }
}
