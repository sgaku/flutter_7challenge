import 'package:flutter/cupertino.dart';
import 'package:flutter_7challenge/view/registration/registration_screen.dart';
import 'package:flutter_7challenge/view/recording_view.dart';
import 'package:flutter_7challenge/view/setting_view.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view_model/auth_provider.dart';
import '../../view_model/notification_provider.dart';
import '../../view_model/user_provider.dart';
import '../top_view.dart';

final launchControllerProvider = Provider((ref) => LaunchController(ref));

class LaunchController {
  LaunchController(this._ref);

  late BuildContext context;
  final Ref _ref;

  Future<void> initialize(BuildContext ctx) async {
    context = ctx;

    final prefs = await SharedPreferences.getInstance();
    _ref.read(switchValueProvider.notifier).update((state) {
      return prefs.getBool('switchValue') ?? false;
    });
    final switchState = _ref.read(switchValueProvider);

    switchState
        ? await _ref.read(notificationProvider).zonedScheduleNotification()
        : await _ref.read(notificationProvider).cancelNotification();

    bool isSignIn = _ref.read(authProvider).isAuthenticated();
    if (isSignIn) {
      final isRecordedController = _ref.read(checkUserRecordProvider.notifier);
      isRecordedController.state =
          await _ref.read(userProvider).isUserAlreadyRecorded();
      await navigateToMain();
    } else {
      await navigateToRegistration();
    }
  }

  Future<void> navigateToMain() async {
    await Navigator.of(context).pushAndRemoveUntil(
      TopView.route(),
      (route) => false,
    );
  }

  Future<void> navigateToRegistration() async {
    await Navigator.of(context).pushAndRemoveUntil(
      RegistrationView.route(),
      (route) => false,
    );
  }
}
