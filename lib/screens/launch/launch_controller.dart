import 'package:flutter/cupertino.dart';
import 'package:flutter_7challenge/Data/firestore/AuthRepository.dart';
import 'package:flutter_7challenge/main.dart';
import 'package:flutter_7challenge/notification.dart';
import 'package:flutter_7challenge/screens/launch/registration_screen.dart';
import 'package:flutter_7challenge/screens/model/check_user.dart';
import 'package:flutter_7challenge/screens/page/RecordingPage.dart';
import 'package:flutter_7challenge/screens/page/SettingPage.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final launchControllerProvider = Provider((_ref) => LaunchController(_ref));

class LaunchController {
  LaunchController(this._ref);

  late BuildContext context;
  final ProviderReference _ref;

  Future<void> initialize(BuildContext ctx) async {
    context = ctx;

    final prefs = await SharedPreferences.getInstance();
    final switchValue = _ref.read(switchValueProvider.notifier);
    switchValue.state = prefs.getBool('switchValue') ?? false;
    final switchState = _ref.read(switchValueProvider);

    switchState
        ? await _ref.read(notificationProvider).zonedScheduleNotification()
        : await _ref.read(notificationProvider).cancelNotification();

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
