import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_7challenge/Data/firestore/AuthRepository.dart';

import 'package:flutter_7challenge/notification.dart';
import 'package:flutter_7challenge/screens/launch/registration_screen.dart';
import 'package:flutter_7challenge/screens/model/check_user_unique.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final switchValueProvider = StateProvider((ref) => false);

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(switchValueProvider);
    final switchValue = ref.read(switchValueProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'メニュー',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(FontAwesomeIcons.twitter),
            title: const Text("開発者のTwitter"),
            onTap: () {
              _twitterUrl();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notification_add),
            title: const Text("通知"),
            trailing: Switch(
              value: state,
              onChanged: (bool value) async {
                switchValue.state = value;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('switchValue', value);
                value
                    ? await ref
                        .read(notificationProvider)
                        .zonedScheduleNotification()
                    : await ref.read(notificationProvider).cancelNotification();
              },
            ),
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
                  iOSAppId: "com.example.flutter7challenge",
                  androidAppId: "com.example.flutter_7challenge");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.drive_file_rename_outline),
            title: const Text("ユーザーネーム変更"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => const ChangeUserDialog());
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
                          const snackBar =
                              SnackBar(content: Text("新しいユーザーネームが登録されました"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
