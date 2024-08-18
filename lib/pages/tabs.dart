import 'package:flutter/material.dart';
import 'add_robot_page.dart';
import 'home_page.dart';

// 底部导航栏
class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _Tabs();
}

class _Tabs extends State<Tabs> {
  List<Widget> pageList = const [HomePage(), HomePage()];

  int select = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pageList[select],
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.all(20),
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
                            blurRadius: 12,
                            spreadRadius: 18,
                          )
                        ]),
                  ),
                  ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                      child: BottomNavigationBar(
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          currentIndex: select,
                          onTap: (index) {
                            setState(() {
                              select = index;
                            });
                          },
                          items: const [
                            BottomNavigationBarItem(
                                icon: Icon(Icons.home), label: "首页"),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.person), label: "我的")
                          ]))
                ])),
          )
        ],
      ),
      floatingActionButton: const AddRobotButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// 添加机器人的按钮
class AddRobotButton extends StatelessWidget {
  const AddRobotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 35),
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
              child: IconButton(
                  // 事件
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext content) {
                      return const AddRobotPage();
                    }));
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 50,
                    color: Colors.white,
                  )),
            )));
  }
}
