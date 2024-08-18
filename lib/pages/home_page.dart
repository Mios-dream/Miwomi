import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';
import '../data/my_app_data.dart';
import 'state_page.dart' as state_page;
import 'plugin_page.dart' as plugin_page;
import 'group_control_page.dart' as group_control_page;
import 'dart:math';

class MyRobotList {
  static List<Widget> robotCards = [
    const BaseRobotCard(
      image: AssetImage("assets/images/Elysia.jpg"),
      name: "爱莉希雅",
      uid: "123342536",
      index: 0,
    ),
    const BaseRobotCard(
      image: AssetImage("assets/images/Elysia.jpg"),
      name: "Elysia",
      uid: "123342536",
      index: 1,
    ),
  ];
}

// 首页主体框架
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: const Color(0xFFF1F3F7),
          backgroundColor: const Color(0xFFF1F3F7),
          leading: IconButton(
              onPressed: () {
                // scaffoldKey.currentState?.openDrawer();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          surfaceTintColor: const Color(0xFFFAEFF1),
                          backgroundColor: const Color(0xFFFAEFF1),
                          // surfaceTintColor: const Color(0xFFF1F3F7),
                          // backgroundColor: const Color(0xFFF1F3F7),
                          contentPadding: const EdgeInsets.all(10),
                          title: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "我的助手",
                                  style: TextStyle(
                                      fontSize: 27,
                                      color: Color(0xFFFF7EAC),
                                      fontFamily: "Sweet"),
                                ),
                                Divider()
                              ]),
                          content: SizedBox(
                            width: 300,
                            height: 400,
                            child: ListView.builder(
                                itemCount: MyRobotList.robotCards.length,
                                itemBuilder: (context, index) {
                                  return MyRobotList.robotCards[index];
                                }),
                          ));
                    });
              },
              icon: const Icon(Icons.view_list_rounded)),
        ),
        body: Container(
            // 撑满整个屏幕
            width: double.infinity,
            decoration: const BoxDecoration(
                // color: Color.fromRGBO(245, 245, 245, 100),
                color: Color(0xFFF1F3F7)),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const HomeMainList()));
  }
}

//基础机器人列表卡片
class BaseRobotCard extends StatefulWidget {
  final ImageProvider image;
  final bool isRunning; // 是否正在运行
  final bool isOnline; // 是否在线
  final bool isSelected; // 是否被选中
  final String name;
  final String uid; // QQ号
  final int level; // 等级
  final int index; //索引

  const BaseRobotCard({
    super.key,
    required this.image,
    required this.name,
    required this.uid,
    required this.index,
    this.isRunning = true,
    this.isOnline = true,
    this.isSelected = false,
    this.level = 0,
  });

  @override
  State<BaseRobotCard> createState() => _BaseRobotCardState();
}

class _BaseRobotCardState extends State<BaseRobotCard> {
  late ImageProvider image;
  late bool isRunning; // 是否正在运行
  late bool isOnline; // 是否在线
  late bool isSelected; // 是否被选中
  late String name;
  late String uid; // QQ号
  late int level; // 等级

  @override
  void initState() {
    image = widget.image;
    isRunning = widget.isRunning;
    isOnline = widget.isOnline;
    isSelected = widget.isSelected;
    name = widget.name;
    uid = widget.uid;
    level = widget.level;
    super.initState();
  }

  Widget _showSelected() {
    if (isSelected) {
      return Positioned(
        top: 15,
        child: Container(
          alignment: Alignment.center,
          height: 20,
          width: 50,
          decoration: const BoxDecoration(
            color: Color(0xFFF784A7),
            borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
          ),
          child: const Text(
            "正在查看",
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);
    isSelected = myAppData.selectedCardIndex == widget.index;
    return GestureDetector(
        onTap: () {
          myAppData.selectCard(widget.index);

          // 在这里添加你的逻辑，比如导航到另一个页面
        },
        onLongPressStart: (LongPressStartDetails details) {
          final size = MediaQuery.of(context).size;
          final paddingDx = size.width - details.globalPosition.dx;
          final paddingDy = size.height - details.globalPosition.dy;
          //更多操作
          showMenu(
              surfaceTintColor: Colors.white,
              context: context,
              position: RelativeRect.fromLTRB(
                details.globalPosition.dx,
                details.globalPosition.dy,
                paddingDx,
                paddingDy,
              ),
              items: [
                const PopupMenuItem(
                  value: 1,
                  child: Text('删除'),
                ),
              ]);
        },
        child: Stack(children: [
          Card(
              surfaceTintColor: Colors.white,
              color: Colors.white,
              child: SizedBox(
                  height: 80,
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(children: [
                        Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFF784A7)
                                      : Colors.grey,
                                  width: 2),
                              image: DecorationImage(
                                  image: image, fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(name),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Lv$level",
                                  style: const TextStyle(
                                    color: Color(0xFFF784A7),
                                  ),
                                ),
                              ],
                            ),
                            Text("uid:$uid",
                                style: const TextStyle(color: Colors.grey))
                          ],
                        )
                      ])))),
          _showSelected(),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  isRunning ? "任职中..." : "休息中...",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFF784A7),
                  ),
                )),
          )
        ]));
  }
}

// 主页内容
class HomeMainList extends StatelessWidget {
  const HomeMainList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Text(
          "你好，阁下！",
          style: TextStyle(
              fontFamily: 'Sweet', fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(
          "2024年8月2日",
          style: TextStyle(
              fontFamily: 'Sweet',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC4D7)),
        ),
        RobotInfo(),
        WeatherInfoCard(),
        SizedBox(
          height: 10,
        ),
        FunctionInfoList()
      ],
    );
  }
}

// 头像及基本信息
class RobotInfo extends StatefulWidget {
  const RobotInfo({super.key});

  @override
  State<RobotInfo> createState() => _RobotInfoState();
}

class _RobotInfoState extends State<RobotInfo> {
  var basicInformation = ["系统Windows", "运行时间3天12时", "内核版本号1.2", "世界第一可爱"];

  List<Widget> getTips() {
    var list = <Widget>[];
    for (var i = 0; i < basicInformation.length; i++) {
      list.add(
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var text = basicInformation[i];
            var textSpan = TextSpan(
              text: text,
              style: const TextStyle(fontSize: 8.0),
            );

            var textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
              maxLines: 1,
            );
            textPainter.layout(maxWidth: constraints.maxWidth);

            var containerWidth = textPainter.width + 15; // Adding padding
            var containerHeight = textPainter.height + 5; // Adding padding

            return Container(
              margin: const EdgeInsets.all(5),
              alignment: Alignment.center,
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                  color: const Color(0xFFFFC4D7),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(text, style: const TextStyle(fontSize: 8.0)),
            );
          },
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      surfaceTintColor: Colors.white,
      shadowColor: const Color(0xFFFFC4D7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 160,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/Elysia.jpg"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20), //设置盒子的圆角
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "爱莉希雅",
                style: TextStyle(fontFamily: 'Sweet', fontSize: 25),
              ),
              const Text(
                "Lv6",
                style: TextStyle(
                    fontFamily: 'Sweet',
                    letterSpacing: 5,
                    fontSize: 15,
                    color: Colors.pinkAccent),
              ),
              SizedBox(
                height: 10,
                width: MediaQuery.of(context).size.width / 2 - 50,
                child: const Divider(thickness: 2),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Wrap(
                    children: getTips(),
                  )),
            ],
          )
        ],
      ),
    );
  }
}

// 天气卡片
class WeatherInfoCard extends StatefulWidget {
  const WeatherInfoCard({super.key});

  @override
  State<WeatherInfoCard> createState() => _WeatherInfoCardState();
}

class _WeatherInfoCardState extends State<WeatherInfoCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return Card(
        elevation: 5,
        surfaceTintColor: Colors.white,
        shadowColor: const Color(0xFFFFC4D7),
        child: Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white, // 边框颜色
                width: 2.0, // 边框宽度
              ),
              image: const DecorationImage(
                  image: AssetImage("assets/images/Elysia.jpg"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20), //设置盒子的圆角
            ),
            child: SizedBox(
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Row(
                      children: [
                        Container(
                            width: 90,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white, // 边框颜色
                                width: 2.0, // 边框宽度
                              ),
                              image: const DecorationImage(
                                  image: AssetImage("assets/images/mio.jpg"),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(20), //设置盒子的圆角
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Center(
                                child: Padding(
                                    padding: width > 400
                                        ? const EdgeInsets.only(right: 20)
                                        : const EdgeInsets.fromLTRB(
                                            0, 10, 20, 0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "今天·34℃·多云",
                                          style: TextStyle(
                                            fontSize: width > 400 ? 25 : 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Text(
                                          "2024年 8月2日 星期四",
                                          style: TextStyle(
                                              fontFamily: 'Sweet',
                                              fontSize: 13,
                                              color: Colors.black54),
                                        ),
                                        Container(
                                          height: 18,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: const Color(0xFF888888)),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("明天 34℃",
                                                  style: TextStyle(
                                                      fontFamily: 'Sweet',
                                                      fontSize: 8,
                                                      color: Colors.white)),
                                              Text("后天 36℃",
                                                  style: TextStyle(
                                                      fontFamily: 'Sweet',
                                                      fontSize: 8,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))))
                      ],
                    ),
                  ),
                ))));
  }
}

// 功能卡片列表
class FunctionInfoList extends StatefulWidget {
  const FunctionInfoList({super.key});

  @override
  State<FunctionInfoList> createState() => _FunctionInfoListState();
}

class _FunctionInfoListState extends State<FunctionInfoList> {
  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // StateInfoCard(),
        BasicFunctionCard(
          value: myAppData.mainSwitch,
          icon: Icons.schema_sharp,
          title: "状态",
          tips: "今天也是正常运行哦",
          jumpPage: const state_page.SatePage(),
          buttonFunction: (value) {
            myAppData.setMainSwitchState(value);
          },
        ),
        BasicFunctionCard(
          value: myAppData.mainPluginSwitch,
          icon: Icons.api,
          title: "插件",
          tips: "成功加载所有插件",
          jumpPage: const plugin_page.PluginPage(),
          buttonFunction: (value) {
            myAppData.setMainPluginSwitchState(value);
          },
        ),
        const BasicFunctionCard(
          value: false,
          icon: Icons.group,
          title: "群聊",
          tips: "成功加载所有群聊",
          jumpPage: group_control_page.GroupControlPage(),
        ),
        Container(
          height: 100, // 通过设置额外元素来,来设置与底部的距离
        )
      ],
    );
  }
}

// 基础功能卡片，用于快捷添加卡片
class BasicFunctionCard extends StatefulWidget {
  final bool value;
  final IconData icon;
  final String title;
  final String tips;
  final Function? buttonFunction;
  final Widget jumpPage;

  const BasicFunctionCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.tips,
      this.buttonFunction,
      required this.jumpPage,
      required this.value});

  @override
  State<BasicFunctionCard> createState() => _BasicFunctionCardState();
}

class _BasicFunctionCardState extends State<BasicFunctionCard> {
  @override
  Widget build(BuildContext context) {
    bool switchValue = widget.value;
    final size = MediaQuery.of(context).size;
    final double width = min(size.width / 2 - 30, 180);

    return Consumer<MyAppData>(builder: (context, counterModel, child) {
      return SizedBox(
          width: width,
          height: max(width * (10 / 9), 200),
          child: Card(
              elevation: 0,
              color: switchValue ? const Color(0xFFFFA3C0) : Colors.white,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.white,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext content) {
                            return widget.jumpPage;
                          }));
                        },
                        icon: Icon(
                          Icons.more_vert,
                          size: 35,
                          color: switchValue ? Colors.white : Colors.black,
                        )),
                    // child: Icon(Icons.schema_sharp)
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: switchValue
                                ? const Color(0xFFFFB4CA)
                                : const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(
                          widget.icon,
                          size: 30,
                          color: switchValue
                              ? Colors.white
                              : const Color(0xFFA9A9A9),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                    fontFamily: 'Sweet',
                                    fontSize: 20,
                                    color: switchValue
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              Text(
                                widget.tips,
                                style: TextStyle(
                                    fontFamily: 'Sweet',
                                    fontSize: 13,
                                    color: switchValue
                                        ? Colors.white70
                                        : Colors.grey),
                              ),
                              Switch(
                                  activeColor: Colors.white,
                                  activeTrackColor: const Color(0xFFFF7EA1),
                                  inactiveThumbColor: const Color(0xFFFF91AE),
                                  inactiveTrackColor: switchValue
                                      ? Colors.white
                                      : const Color(0xFFF1F1F1),
                                  trackOutlineColor:
                                      MaterialStateProperty.resolveWith(
                                          (Set states) {
                                    return Colors
                                        .transparent; // Use the default color.
                                  }),
                                  value: switchValue,
                                  onChanged: (bool value) {
                                    setState(() {
                                      switchValue = value; // 更新状态
                                    });
                                    widget.buttonFunction!(value);
                                  })
                            ],
                          ))
                    ],
                  )
                ],
              )));
    });
  }
}
