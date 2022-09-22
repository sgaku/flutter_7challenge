import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_7challenge/Data/firestore/AuthRepository.dart';
import 'package:flutter_7challenge/main.dart';
import 'package:flutter_7challenge/screens/model/check_user_unique.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userNameProvider = StateProvider((ref) {
  return "";
});
final userUniqueStateProvider = StateProvider((ref) {
  return true;
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
    final state = ref.watch(userNameProvider);
    final isUniqueState = ref.watch(userUniqueStateProvider);
    final isUniqueStateNotifier = ref.watch(userUniqueStateProvider.notifier);
    final notifier = ref.watch(userNameProvider.notifier);
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
                onChanged: (text) async {
                  notifier.state = text;
                  isUniqueStateNotifier.state = await ref
                      .read(userUniqueRepositoryProvider)
                      .isUniqueUser(name: text);
                },
              ),
            ),
            ElevatedButton(
                onPressed: state.isEmpty || !isUniqueState
                    ? !isUniqueState
                        ? () {
                            print(isUniqueState);
                            const snackBar =
                                SnackBar(content: Text("そのユーザーネームは既に登録されています"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        : null
                    : () async {
                        print(isUniqueState);
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
