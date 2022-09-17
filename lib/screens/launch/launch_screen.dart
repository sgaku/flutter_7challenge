import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'launch_controller.dart';

class LaunchScreen extends HookConsumerWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  static const routeName = '/launch';

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    useEffect((){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.watch(launchControllerProvider).initialize(context);
      });
    },[]);
    return const Scaffold(
      body: SizedBox.shrink(),
    );
  }
}