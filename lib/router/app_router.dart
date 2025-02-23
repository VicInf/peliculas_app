import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peliculas_app/presentation/screens/detail/movie_details_screen.dart';
import 'package:peliculas_app/presentation/screens/home/home_screen.dart';
import 'package:peliculas_app/presentation/screens/profile/profile_screen.dart';
import 'package:peliculas_app/router/app_router_constants.dart';

class AppRouter {
  static final AppRouter _singleton = AppRouter._internal();

  factory AppRouter() {
    return _singleton;
  }

  AppRouter._internal();

  final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        name: AppRouterConstants.home,
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomeScreen());
        },
      ),
      GoRoute(
        path: '/details',
        name: AppRouterConstants.movieDetails,
        pageBuilder: (context, state) {
          final movies = state.extra as Map<String, dynamic>;
          return MaterialPage(
              child: MovieDetailsScreen(
            movie: movies,
          ));
        },
      ),
      GoRoute(
        path: '/profile/:actorId',
        name: AppRouterConstants.profileScreen,
        pageBuilder: (context, state) {
          final actorId = state.pathParameters['actorId'];
          return MaterialPage(
              child: ProfileScreen(
            actorId: actorId!,
          ));
        },
      ),
    ],
  );
}
