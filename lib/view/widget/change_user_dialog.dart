import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Data/repository/auth_repository.dart';
import '../../Data/repository/user_repository.dart';
import '../registration/registration_screen.dart';

class ChangeUserDialog extends ConsumerWidget {
  const ChangeUserDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);
    final isUniqueUser = ref.watch(userUniqueProvider);
    final userNameController = ref.watch(userNameProvider.notifier);
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(hintText: 'ユーザーネームを変更しよう'),
            onChanged: (text) async {
              userNameController.state = text;
              final isUnique = ref.read(userUniqueProvider.notifier);
              isUnique.state =
                  await ref.read(userProvider).isUniqueUser(name: text);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: isUniqueUser || userName.isEmpty
                  ? isUniqueUser
                      ? () async {
                          const snackBar =
                              SnackBar(content: Text("新しいユーザーネームが登録されました"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          final uid = ref.read(authProvider).getUid();
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(uid)
                              .update({
                            'name': userName,
                          });
                          Navigator.pop(context);
                        }
                      : null
                  : () {
                      const snackBar =
                          SnackBar(content: Text("そのユーザーネームは既に登録されています"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
              child: const Text('完了')),
        )
      ],
    );
  }
}
