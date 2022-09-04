import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key, }) : super(key: key);


  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定画面'),
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("開発者について"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.notification_add),
            title: Text("通知設定"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.share),
            title: Text("シェアする"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.star),
            title: Text("評価する"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.drive_file_rename_outline),
            title: const Text("ユーザーネーム変更"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    children: [
                      TextField(
                        decoration:
                        const InputDecoration(hintText: 'ユーザーネーム'),
                        onChanged: (text) {
                          setState(() {
                            username = text;
                          });
                        },
                      ),
                      TextButton(
                        child: const Text('完了'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ));
            },
          ),
        ],
      ),
    );
  }
}