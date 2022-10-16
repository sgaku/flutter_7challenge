import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ranking_notifier.dart';


final bottomNavigationIndexProvider = ChangeNotifierProvider((ref) {
  return BottomNavigationIndex();
});

class BottomNavigationIndex extends ChangeNotifier {
  int selectedIndex = 0;

  void onTapItem(int i, RankingNotifier notifier) {
    notifier.fetchRankingList();
    selectedIndex = i;
    notifyListeners();
  }
}
