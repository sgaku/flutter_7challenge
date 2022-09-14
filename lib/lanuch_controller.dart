
import 'package:flutter/cupertino.dart';
import 'package:flutter_7challenge/AuthRepository.dart';
import 'package:flutter_7challenge/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final launchControllerProvider = Provider((_ref) => LaunchController(_ref));

class LaunchController {
  LaunchController(this._ref);
  late BuildContext context;
  final ProviderReference _ref;

  Future<void> initialize(BuildContext ctx) async {
    context = ctx;
    await signIn();
    await navigateToMap();
  }

  Future<void> signIn() async {
    try {
      await _ref.read(authRepositoryProvider).signIn();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> navigateToMap() async {
    await Navigator.of(context).pushReplacement(MainPage.route());
  }
}