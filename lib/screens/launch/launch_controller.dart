import 'package:flutter/cupertino.dart';
import 'package:flutter_7challenge/Data/firestore/AuthRepository.dart';
import 'package:flutter_7challenge/main.dart';
import 'package:flutter_7challenge/screens/launch/registration_screen.dart';
import 'package:flutter_7challenge/screens/model/check_user.dart';
import 'package:flutter_7challenge/screens/page/RecordingPage.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

final launchControllerProvider = Provider((_ref) => LaunchController(_ref));

class LaunchController {
  LaunchController(this._ref);

  late BuildContext context;
  final ProviderReference _ref;

  Future<void> initialize(BuildContext ctx) async {
    context = ctx;


    bool isSignIn = _ref.read(authRepositoryProvider).isAuthenticated();
    if (isSignIn) {
      final isRecordedController = _ref.read(checkUserBoolProvider.notifier);
      isRecordedController.state =
      await _ref.read(checkUserProvider).checkUserDocs();
      await navigateToMain();
    } else {
      await signIn();
      await navigateToRegistration();
    }
  }

  Future<void> signIn() async {
    try {
      await _ref.read(authRepositoryProvider).signIn();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> navigateToMain() async {
    await Navigator.of(context).pushAndRemoveUntil(
      MainPage.route(),
      (route) => false,
    );
  }

  Future<void> navigateToRegistration() async {
    await Navigator.of(context).pushAndRemoveUntil(
      Registration.route(),
      (route) => false,
    );
  }
}
