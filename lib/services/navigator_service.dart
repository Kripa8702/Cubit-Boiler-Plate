import 'package:cubit_boiler_plate/routing/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigatorService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  static GoRouter get router => AppRouting.router;

  static Future<dynamic> push(String routeName, {dynamic arguments}) async {

    return router.push(routeName, extra: arguments);
  }

  static Future<dynamic> pushReplacement(String routeName, {dynamic arguments}) async {

    return router.pushReplacement(routeName, extra: arguments);
  }

  static Future<dynamic> go(String routeName,
      {dynamic arguments}) async {

    return router.go(routeName, extra: arguments);
  }

  static void goBack() {
    return router.pop();
  }
}
