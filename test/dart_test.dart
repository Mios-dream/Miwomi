import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './tools/music_manager.dart';
import 'package:oktoast/oktoast.dart';
import './router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MusicManager()),
        ],
        child: OKToast(
            // 这一步
            child: MaterialApp.router(
          routerConfig: AppRouter.router,
        )));
  }
}
