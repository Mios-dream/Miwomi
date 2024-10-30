import 'package:flutter/material.dart';
import 'pages/tabs.dart';
import 'package:provider/provider.dart';
import 'data/my_app_data.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:async';
import './pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Map<String, WidgetBuilder> routes = {
    '/': (context) => const Tabs(),
    '/HomePage': (context) => const HomePage(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MyAppData(),
        child: OKToast(
            // 这一步
            child: MaterialApp(
          routes: routes,
          theme: ThemeData(
              textTheme:
                  const TextTheme(bodyLarge: TextStyle(fontFamily: "Sweet")),
              switchTheme: SwitchThemeData(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              )),
          debugShowCheckedModeBanner: false,
          title: '澪之梦',
          home: const SplashScreen(),
        )));
  }
}

// 启动页
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  void _navigateToMainScreen() {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Tabs()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // 初始读取数据
    Provider.of<MyAppData>(context).initData();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // 图片位于页面中心并自适应页面大小
          Center(
            child: Image.asset(
              'assets/images/start2.png', // 图片路径
              fit: BoxFit.contain, // 自适应页面
              width: MediaQuery.of(context).size.width * 0.9, // 控制图片宽度
            ),
          ),
          // 底部的圆形加载进度条
          const Positioned(
            bottom: 40.0, // 距离页面底部的距离
            left: 0,
            right: 0,
            child: Center(
                // child: CircularProgressIndicator(
                //   strokeWidth: 5.0,
                // ),
                child: Text(
              'Miwomi',
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 25,
                fontFamily: 'logo',
              ),
            )),
          ),
        ],
      ),
    );
  }
}
