import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'addRobot.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const OKToast(
        // 这一步
        child: MaterialApp(
      home: Tabs(),
    ));
  }
}

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _Tabs();
}

class _Tabs extends State<Tabs> {
  PageController pageController = PageController(initialPage: 0);
  int select = 0;
  bool isAdd = false;
  List<Widget> pageList = [Container(), const UnityDemoScreen()];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void previousPage() {
    pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void jumpToPage(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    // 初始化时判断是否为空，否者进入机器人添加界面
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
              controller: pageController,
              onPageChanged: (int page) {
                setState(() {
                  select = page;
                });
              },
              children: pageList),
          AnimatedPositioned(
              bottom: select == 0 ? 20 : -100,
              right: 20,
              left: 20,
              duration: const Duration(milliseconds: 300),
              child: Stack(children: [
                Container(
                  width: double.infinity,
                  height: 57,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          spreadRadius: 5,
                        )
                      ]),
                ),
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    child: BottomNavigationBar(
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        currentIndex: select,
                        onTap: (index) {
                          setState(() {
                            select = index;
                            jumpToPage(index);
                          });
                        },
                        items: const [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.home), label: "首页"),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.person), label: "我的")
                        ]))
              ])),
          AnimatedPositioned(
              curve: Curves.easeIn,
              bottom: isAdd ? 170 : 40,
              right: select == 0 ? size.width / 2 - 35 : 50,
              duration: const Duration(milliseconds: 300),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF795B1),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFF795B1),
                            blurRadius: 15,
                          )
                        ],
                      ),
                      child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: select == 0
                              ? IconButton(
                                  key: UniqueKey(),
                                  // 事件
                                  onPressed: () {
                                    setState(() {
                                      isAdd = true;
                                    });
                                    Timer(const Duration(milliseconds: 500),
                                        () {
                                      setState(() {
                                        isAdd = false;
                                      });

                                      Navigator.of(context)
                                          .push(PageRouteBuilder(
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const AddRobotPage(),
                                      ));
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    size: 50,
                                    color: Colors.white,
                                  ))
                              : IconButton(
                                  key: UniqueKey(),
                                  // 事件
                                  onPressed: () {
                                    setState(() {
                                      select = 0;
                                      jumpToPage(select);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.chevron_left,
                                    size: 50,
                                    color: Colors.white,
                                  ))))))
        ],
      ),
    );
  }
}

class UnityDemoScreen extends StatefulWidget {
  const UnityDemoScreen({Key? key}) : super(key: key);

  @override
  State<UnityDemoScreen> createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityDemoScreen> {
  UnityWidgetController? _unityWidgetController;

  void showMessage(Map data) {
    String text = data['text'];
    double textSize = 14;
    final size = MediaQuery.of(context).size;
    final TextPainter textPainter = TextPainter(
      maxLines: null,
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: textSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    double textHeight = textPainter.height;
    showToastWidget(
      Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(10, 400, 10, 100),
          width: size.width * 0.9,
          height: textHeight + 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.pink.shade200, width: 1),
          ),
          child: TextFadeInAnimation(
            text: text,
            fontSize: textSize,
          )),
      duration: Duration(seconds: data['duration'].ceil()),
      animationCurve: Curves.easeIn,
      position: ToastPosition.center,
    );
  }

  void _sendPlayMotionMessage() {
    _unityWidgetController?.postMessage(
        '兔绒free', // 组件名
        'PlayAnimation', // 函数名
        '待机'); // 动作名
  }

  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  void onUnityMessage(message) {
    showMessage(jsonDecode(message));
    print('接收到消息: ${message.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: UnityWidget(
            printSetupLog: false,
            onUnityCreated: onUnityCreated,
            onUnityMessage: onUnityMessage,
          ),
        ),
      ]),
    ));
  }
}

class TextFadeInAnimation extends StatefulWidget {
  final String text;
  final double fontSize;

  const TextFadeInAnimation(
      {super.key, required this.text, required this.fontSize});

  @override
  State<TextFadeInAnimation> createState() => _TextFadeInAnimationState();
}

class _TextFadeInAnimationState extends State<TextFadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final int _durationPerCharacter = 100; // 每个字符显示的时间间隔（毫秒）

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:
          Duration(milliseconds: _durationPerCharacter * widget.text.length),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward(); // 开始动画
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2.0, // 字符之间的间距
      children: List.generate(widget.text.length, (index) {
        double opacity =
            (_animation.value * widget.text.length - index).clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Text(
            widget.text[index],
            style: TextStyle(fontSize: widget.fontSize, color: Colors.black),
          ),
        );
      }),
    );
  }
}
