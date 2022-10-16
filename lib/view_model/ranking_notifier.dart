import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_7challenge/Data/model/user_data.dart';
import 'package:flutter_7challenge/Data/model/user_state.dart';
import 'package:flutter_7challenge/common/method/format_for_now.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rankingStateProvider = StateNotifierProvider<RankingNotifier, UserDataState>(
    (ref) => RankingNotifier());

class RankingNotifier extends StateNotifier<UserDataState> {
  RankingNotifier() : super(const UserDataState());

  Future<void> fetchRankingList() async {
    var date = formatForNow();
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ranking')
        .doc(date)
        .collection('ranking')
        .orderBy('time')
        .limit(100)
        .get();

    final List<UserData> list = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String time = data['time'];
      final String user = data['user'];
      final String uid = data['uid'];
      final userData = const UserData().copyWith(time: time, user: user, uid: uid);
      return userData;
    }).toList();
    state = state.copyWith(userList: list);
  }
}

