import 'package:flutter/material.dart';
import 'package:flutter_7challenge/screens/model/Ranking.dart';
import 'package:flutter_7challenge/screens/page/RecordingPage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final rankingProvider = ChangeNotifierProvider((ref) {
  return Ranking();
});

class RankingPage extends ConsumerWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var now = DateTime.now();
    final value = ref.watch(rankingProvider);
    final isRecorded = ref.watch(checkUserBoolProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '今日のランキング',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: !isRecorded
          ?  Center(
              child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              title: const Text("記録しにいこう！"),
              content: const Text("あなたが記録するまで、ランキングを見ることができません"),
            ))
          : ListView.separated(
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
