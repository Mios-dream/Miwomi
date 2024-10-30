import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../lib/music_page.dart';
import '../lib/player_page.dart';
import "../lib/search_page.dart";

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        name: 'musicPage',
        path: '/',
        builder: (context, state) => const MusicPage(),
      ),
      GoRoute(
        name: 'playerPage',
        path: '/player',
        builder: (context, state) => const PlayerPage(),
      ),
      GoRoute(
          name: 'searchPage',
          path: '/searchPage',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const SearchPage(),
              barrierDismissible: true,
              barrierColor: Colors.black38,
              opaque: false,
              transitionDuration: const Duration(milliseconds: 200),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          }),
    ],
  );
}
