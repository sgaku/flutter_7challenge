import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_7challenge/view/launch/launch_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final routerProvider = Provider((_) => _Router());

class _Router {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LaunchView.routeName:
        return fadeRoute(const LaunchView(), settings);
      default:
        return fadeRoute(const LaunchView(), settings);
    }
  }
}

Route fadeRoute(Widget to, RouteSettings settings) {
  return PageRouteBuilder<dynamic>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => to,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<double>(
        begin: 0,
        end: 1,
      ).chain(CurveTween(curve: Curves.ease));

      return FadeTransition(
        opacity: animation.drive(tween),
        child: to,
      );
    },
  );
}