import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peliculas_app/presentation/screens/home/home_screen.dart';
import 'package:peliculas_app/router/app_router_constants.dart';

class AppRouter {
  static final AppRouter _singleton = AppRouter._internal();

  factory AppRouter() {
    return _singleton;
  }

  AppRouter._internal();

  final GoRouter router = GoRouter(routes: [
    GoRoute(
      path: '/',
      name: AppRouterConstants.home,
      pageBuilder: (context, state) {
        return const MaterialPage(child: HomeScreen());
      },
    )
  ]);
}
