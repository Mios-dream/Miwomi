import 'package:flutter/material.dart';
import 'pages/tabs.dart';
import 'package:provider/provider.dart';
import 'data/my_app_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MyAppData(),
        child: MaterialApp(
          theme: ThemeData(
              textTheme:
                  const TextTheme(bodyLarge: TextStyle(fontFamily: "Sweet")),
              switchTheme: SwitchThemeData(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              )),
          debugShowCheckedModeBanner: false,
          title: '澪之梦',
          home: const Tabs(),
        ));
  }
}
