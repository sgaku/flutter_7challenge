import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_7challenge/common/class/record_alert_dialog.dart';
import 'package:flutter_7challenge/main.dart';
import 'package:flutter_7challenge/view_model/ranking_notifier.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:analog_clock/analog_clock.dart';

import '../Data/repository/user_repository.dart';
import '../common/method/format_for_now.dart';

final nowProvider = StateProvider((ref) {
  return "";
});

final checkUserRecordProvider = StateProvider((ref) {
  return false;
});

class RecordingView extends ConsumerStatefulWidget {
  const RecordingView({super.key});

  @override
  RecordPageState createState() => RecordPageState();
}

class RecordPageState extends ConsumerState<RecordingView> {
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
    final time = ref.watch(nowProvider);
    final isRecorded = ref.watch(checkUserRecordProvider);
    // final auth = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '今日のチャレンジ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isRecorded || now.hour <= 6 || now.hour >= 8
          ? isRecorded
              ? const RecordAlertDialog(
                  title: Text("今日のチャレンジは終わりました"),
                  content: Text("今日の記録が既に存在します。また明日チャレンジしましょう"))
              : const RecordAlertDialog(
                  title: Text("今日のチャレンジは終わりました"),
                  content: Text("AM7:00-8:00を過ぎました。また明日チャレンジしましょう"))
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
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: isRecorded
                        ? null
                        : () async {
                            onPressedTime = time;
                            await addData();
                            final isRecordedController =
                                ref.read(checkUserRecordProvider.notifier);
                            isRecordedController.state = await ref
                                .read(userProvider)
                                .isUserAlreadyRecorded();
                            await ref
                                .read(rankingStateProvider.notifier)
                                .fetchRankingList();
                            final ranking = ref.read(rankingStateProvider);
                            final list = ranking.userList!;
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
                ],
              ),
            ),
    );
  }

  void _onTimer(Timer timer) {
    var now = DateTime.now();
    var dateFormat = DateFormat('HH:mm:ss');
    var timeString = dateFormat.format(now);
    ref.read(nowProvider.notifier).update((state) => state = timeString);
  }

  Future addData() async {
    final username = await ref.read(userProvider).fetchUser();
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;

    var date = formatForNow();
    await FirebaseFirestore.instance
        .collection('ranking')
        .doc(date)
        .collection('ranking')
        .add({
      'time': onPressedTime,
      'user': username,
      'uid': uid,
    });
  }
}
