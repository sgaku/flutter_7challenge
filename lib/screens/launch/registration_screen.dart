import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_7challenge/Data/firestore/AuthRepository.dart';
import 'package:flutter_7challenge/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider = StateProvider((ref) {
  return "";
});

class Registration extends ConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const Registration(),
    );
  }

  const Registration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider);
    final notifier = ref.watch(userProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー登録'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (text) {
                  notifier.state = text;
                },
              ),
            ),
            ElevatedButton(
                onPressed: state.isEmpty
                    ? null
                    : () async {
                        final uid = ref.read(authRepositoryProvider).getUid();
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(uid)
                            .set({
                          'name': state,
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                          MainPage.route(),
                          (route) => false,
                        );
                      },
                child: const Text('ユーザーネームを登録してね'))
          ],
        ),
      ),
    );
  }
}
