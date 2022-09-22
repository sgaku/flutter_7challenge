import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_7challenge/Data/firestore/AuthRepository.dart';
import 'package:flutter_7challenge/screens/launch/registration_screen.dart';
import 'package:flutter_7challenge/screens/model/check_user_unique.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userNameProvider);
    final isUniqueUser = ref.watch(userUniqueStateProvider);
    final notifier = ref.watch(userNameProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定画面'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text("開発者について"),
            onTap: () {
              _twitterUrl();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notification_add),
            title: const Text("通知設定"),
            onTap: () {
              showDialog(context: context, builder: (context) => ChangeUserDialog());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("シェアする"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text("評価する"),
            onTap: () {
              LaunchReview.launch(
                  iOSAppId: "com.gaku.flutter7challenge",
                  androidAppId: "com.example.flutter_7challenge");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.drive_file_rename_outline),
            title: const Text("ユーザーネーム変更"),
            onTap: () {
              showDialog(context: context, builder: (context) => ChangeUserDialog());
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _twitterUrl() async {
  Uri twitterLink = Uri.parse('https://twitter.com/5fmclNZlCEw8jeg');
  if (!await launchUrl(
    twitterLink,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
  )) {
    throw 'Could not launch $twitterLink';
  }
}

class ChangeUserDialog extends ConsumerWidget {
  const ChangeUserDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userNameProvider);
    final isUniqueUser = ref.watch(userUniqueStateProvider);
    final notifier = ref.watch(userNameProvider.notifier);
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(hintText: 'ユーザーネーム'),
            onChanged: (text) async {
              notifier.state = text;
              final isUnique = ref.read(userUniqueStateProvider.notifier);
              isUnique.state = await ref
                  .read(userUniqueRepositoryProvider)
                  .isUniqueUser(name: text);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: isUniqueUser || state.isEmpty
                  ? isUniqueUser
                      ? () async {
                          final uid = ref.read(authRepositoryProvider).getUid();
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(uid)
                              .update({
                            'name': state,
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

