import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ranking_notifier.dart';

final navigationIndexProvider =
    StateNotifierProvider<NavigationIndexNotifier, int>(
        (ref) => NavigationIndexNotifier());

class NavigationIndexNotifier extends StateNotifier<int> {
  NavigationIndexNotifier() : super(0);

  void onTapItem(int index, RankingNotifier notifier) {
    notifier.fetchRankingList();
    state = index;
  }
}
