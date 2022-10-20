import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeNotificationMessageDialog extends ConsumerWidget {
  const ChangeNotificationMessageDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String notificationMessage = "";
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(hintText: '通知メッセージを変更しよう'),
            onChanged: (text) async {
              notificationMessage = text;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                await pref.setString('notification', notificationMessage);
                Navigator.pop(context);
              },
              child: const Text('完了')),
        )
      ],
    );
  }
}
