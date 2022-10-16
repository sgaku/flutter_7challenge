import 'package:flutter/material.dart';
import 'package:flutter_7challenge/view_model/ranking_notifier.dart';
import 'package:flutter_7challenge/view/recording_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/class/record_alert_dialog.dart';

class RankingView extends ConsumerWidget {
  const RankingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ranking = ref.watch(rankingStateProvider);
    final isRecorded = ref.watch(checkUserRecordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '今日のランキング',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: !isRecorded
          ? const RecordAlertDialog(
              title: Text("記録しにいこう！"),
              content: Text("あなたが記録するまで、ランキングを見ることができません"))
          : ListView.separated(
              itemBuilder: (context, index) => ListTile(
                leading: ExcludeSemantics(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(ranking.userList![index].user),
                subtitle: Text(ranking.userList![index].time),
              ),
              separatorBuilder: (context, index) {
                return const Divider(height: 0.5);
              },
              itemCount: ranking.userList!.length,
            ),
    );
  }
}
