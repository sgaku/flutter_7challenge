import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ranking_view.dart';
import 'recording_view.dart';
import 'setting_view.dart';
import '../view_model/bottom_navigation_index.dart';

class TopView extends ConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const TopView(),
    );
  }

  const TopView({Key? key}) : super(key: key);

  static const _screen = [
    RecordingView(),
    RankingView(),
    SettingView(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(bottomNavigationIndexProvider);
    final rankValue = ref.watch(rankingProvider);

    return Scaffold(
      body: _screen[value.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: value.selectedIndex,
        onTap: (int index) => value.onTapItem(index, rankValue),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.touch_app), label: '記録する'),
          BottomNavigationBarItem(icon: Icon(Icons.reorder), label: 'ランキング'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'メニュー'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
