import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_7challenge/Data/repository/auth_repository.dart';

import 'package:flutter_7challenge/Data/repository/notification_repository.dart';
import 'package:flutter_7challenge/view/registration/registration_screen.dart';
import 'package:flutter_7challenge/view_model/check_user_unique.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              _twitterUrl();
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
              _contactUrl();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text("プライバシーポリシー"),
            onTap: () {
              _policyUrl();
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _contactUrl() async {
  Uri contactLink = Uri.parse(
      'https://chain-thrill-de7.notion.site/358cb66bb9f1464a9bf75042c695ebf9');
  if (!await launchUrl(
    contactLink,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
  )) {
    throw 'Could not launch $contactLink';
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

Future<void> _policyUrl() async {
  Uri policyUrl = Uri.parse(
      'https://chain-thrill-de7.notion.site/f3e4ceea269c469f9deb012cd84f2a47');
  if (!await launchUrl(
    policyUrl,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
  )) {
    throw 'Could not launch $policyUrl';
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
            decoration: const InputDecoration(hintText: 'ユーザーネームを変更しよう'),
            onChanged: (text) async {
              notifier.state = text;
              final isUnique = ref.read(userUniqueStateProvider.notifier);
              isUnique.state = await ref
                  .read(checkUserUniqueProvider)
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
                          final uid = ref.read(authProvider).getUid();
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
