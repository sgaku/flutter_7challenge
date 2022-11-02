import 'package:flutter/material.dart';
import 'package:flutter_7challenge/common/constraints/url.dart';
import 'package:flutter_7challenge/view/widget/change_notification_message_dialog.dart';
import 'package:flutter_7challenge/view/widget/change_user_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../view_model/notification_provider.dart';

final switchValueProvider = StateProvider((ref) => false);

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  SettingViewState createState() => SettingViewState();
}

class SettingViewState extends ConsumerState<SettingView> {
  String notificationBar = "";

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
                final pref = await SharedPreferences.getInstance();
                await pref.setBool('switchValue', value);

                if (value) {
                  await ref
                      .read(notificationProvider)
                      .zonedScheduleNotification();
                  notificationBar = "通知がオンになりました";
                } else {
                  await ref.read(notificationProvider).cancelNotification();
                  notificationBar = "通知がオフになりました";
                }
                final snackBar = SnackBar(content: Text(notificationBar));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => ChangeNotificationMessageDialog());
            },
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
