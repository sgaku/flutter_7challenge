import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../state_management/Ranking.dart';



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
