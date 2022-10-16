import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_7challenge/Data/repository/auth_repository.dart';

import 'package:flutter_7challenge/Data/repository/notification_repository.dart';
import 'package:flutter_7challenge/Data/repository/user_repository.dart';
import 'package:flutter_7challenge/common/class/url.dart';
import 'package:flutter_7challenge/view/registration/registration_screen.dart';
import 'package:flutter_7challenge/view_model/check_user_unique.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final switchValueProvider = StateProvider((ref) => false);

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  SettingViewState createState() => SettingViewState();
}

class SettingViewState extends ConsumerState<SettingView> {
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
            leading: const Icon(FontAwesomeIcons.twitter),
            title: const Text("開発者のTwitter"),
            onTap: () {
              moveUrl(Uri.parse(Url.twitter));
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
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.share),
          //   title: const Text("シェアする"),
          //   onTap: () {},
          // ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.star),
          //   title: const Text("評価する"),
          //   onTap: () {
          //     LaunchReview.launch(
          //         iOSAppId: "com.gaku.flutter7challenge",
          //         androidAppId: "com.example.flutter_7challenge");
          //   },
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text("お問い合わせ"),
            onTap: () {
              moveUrl(Uri.parse(Url.contact));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text("プライバシーポリシー"),
            onTap: () {
              moveUrl(Uri.parse(Url.privacyPolicy));
            },
          ),
        ],
      ),
    );
  }
}

Future<void> moveUrl(Uri uri) async {
  if (!await launchUrl(
    uri,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
  )) {
    throw 'Could not launch $uri';
  }
}

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
              isUnique.state = await ref
                  .read(userProvider)
                  .isUniqueUser(name: text);
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
