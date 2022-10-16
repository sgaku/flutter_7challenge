import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Ranking.dart';

final bottomNavigationIndexProvider = ChangeNotifierProvider((ref) {
  return BottomNavigationIndex();
});

class BottomNavigationIndex extends ChangeNotifier {
  int selectedIndex = 0;

  void onTapItem(int i, Ranking rankValue) {
    rankValue.fetchRankingList();
    selectedIndex = i;
    notifyListeners();
  }
}
