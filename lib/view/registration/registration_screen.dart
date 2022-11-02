import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../view_model/auth_provider.dart';
import '../../view_model/user_provider.dart';
import '../top_view.dart';

final userNameProvider = StateProvider((ref) {
  return "";
});
final userUniqueProvider = StateProvider((ref) {
  return true;
});

final isIndicateProvider = StateProvider((ref) => false);

class RegistrationView extends ConsumerStatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const RegistrationView(),
    );
  }

  @override
  RegistrationViewState createState() => RegistrationViewState();

  const RegistrationView({super.key});
}

class RegistrationViewState extends ConsumerState<RegistrationView> {
  @override
  Widget build(BuildContext context) {
    final userName = ref.watch(userNameProvider);
    final isUniqueUser = ref.watch(userUniqueProvider);
    final userNameController = ref.watch(userNameProvider.notifier);
    final isIndicate = ref.watch(isIndicateProvider);
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text(
            'ユーザー登録',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  onChanged: (text) async {
                    userNameController.state = text;
                    final isUniqueController =
                        ref.read(userUniqueProvider.notifier);
                    isUniqueController.state =
                        await ref.read(userProvider).isUniqueUser(name: text);
                  },
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: userName.isEmpty || !isUniqueUser
                      ? !isUniqueUser
                          ? () {
                              const snackBar = SnackBar(
                                  content: Text("そのユーザーネームは既に登録されています"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          : null
                      : () async {
                          final isIndicateController =
                              ref.read(isIndicateProvider.notifier);
                          try {
                            isIndicateController.state = true;
                            await signIn();
                            final uid = ref.read(authProvider).getUid();
                            await FirebaseFirestore.instance
                                .collection('user')
                                .doc(uid)
                                .set({
                              'name': userName,
                            });
                          } finally {
                            isIndicateController.state = false;
                            Navigator.of(context).pushAndRemoveUntil(
                              TopView.route(),
                              (route) => false,
                            );
                          }
                        },
                  child: const Text('ユーザーネームを登録してね'))
            ],
          ),
        ),
      ),
      if (isIndicate)
        const ColoredBox(
          color: Colors.black54,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
    ]);
  }

  Future<void> signIn() async {
    try {
      await ref.read(authProvider).signIn();
    } on Exception catch (e) {
      print(e);
    }
  }
}
