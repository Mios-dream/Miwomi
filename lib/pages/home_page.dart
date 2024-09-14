import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';
import '../widgets/toast.dart';
import '../data/my_app_data.dart';
import 'state_page.dart' as state_page;
import 'plugin_page.dart' as plugin_page;
import 'group_control_page.dart' as group_control_page;
import 'dart:math';
import 'package:http/http.dart' as http;

// 首页主体框架
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);
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
                                itemCount: myAppData.robots.length,
                                itemBuilder: (context, index) {
                                  // 滑动删除
                                  return Dismissible(
                                    key: ValueKey(myAppData.robots[index]),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      setState(() {
                                        if (index ==
                                            myAppData.selectedCardIndex) {
                                          myAppData.selectCard(0);
                                        }
                                        myAppData.removeRobot(index);
                                      });
                                    },
                                    background: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFE9AC1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(Icons.delete),
                                    ),
                                    child: BaseRobotCard(
                                      index: index,
                                      robotInfo: myAppData.robots[index],
                                    ),
                                  );
                                }),
                          ));
                    });
              },
              icon: const Icon(Icons.view_list_rounded)),
        ),
        body: myAppData.isAvailable
            ? Container(
                // 撑满整个屏幕
                width: double.infinity,
                decoration: const BoxDecoration(
                    // color: Color.fromRGBO(245, 245, 245, 100),
                    color: Color(0xFFF1F3F7)),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const HomeMainList())
            : Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Color(0xFFF1F3F7)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Text(
                    //   "OωO",
                    //   style: TextStyle(
                    //     fontSize: 30,
                    //   ),
                    // ),
                    Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/error.png"),
                          ),
                        )),
                    const Text(
                      "当前机器人好像不可用",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 25,
                          fontFamily: "Sweet"),
                    ),
                    Container(
                      width: 130,
                      height: 50,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFB9BB5),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFFB9BB5),
                              spreadRadius: 0,
                              blurRadius: 10,
                            )
                          ]),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            myAppData.checkAvailable();
                          });
                        },
                        child: const Text(
                          "点击重连",
                          style: TextStyle(
                              fontFamily: "Sweet", color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ));
  }
}

//基础机器人列表卡片
class BaseRobotCard extends StatefulWidget {
  final Map robotInfo; // 机器人信息

  final int index; //索引

  const BaseRobotCard({
    super.key,
    required this.index,
    required this.robotInfo,
  });

  @override
  State<BaseRobotCard> createState() => _BaseRobotCardState();
}

class _BaseRobotCardState extends State<BaseRobotCard> {
  late bool isOnline = false; // 是否在线
  late bool isSelected; // 是否被选中
  int level = 0; // 等级
  bool isRunning = true; // 是否正在运行

  @override
  void initState() {
    super.initState();

    available(widget.robotInfo["address"]);
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

  Future<bool> available(String address) async {
    try {
      final response = await http
          .get(Uri.parse("$address/bot_info"))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        isOnline = true;
      }
    } catch (_) {}

    setState(() {});

    return isOnline;
  }

  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);

    isSelected = myAppData.selectedCardIndex == widget.index;
    return GestureDetector(
        onTap: () {
          if (isSelected) {
            return;
          }
          // 此处发送一个请求，判断机器人是否可用
          available(myAppData.robots[widget.index]["address"]).then((value) {
            if (value) {
              myAppData.selectCard(widget.index);
            } else {
              notificationToast(text: '机器人不可用，地址错误或链接超时', level: 3);
            }
          });
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
                                  image: NetworkImage(
                                      "https://q1.qlogo.cn/g?b=qq&nk=${widget.robotInfo["user_id"]}&s=5"),
                                  fit: BoxFit.cover),
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
                                Text(widget.robotInfo["name"]),
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
                            Text("uid:${widget.robotInfo["user_id"]}",
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 15),
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
          ),
          Container(
            margin: const EdgeInsets.only(top: 65, left: 90, right: 35),
            width: double.infinity,
            height: 10,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Color(0xFFF7C5D6)),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(top: 65, right: 20),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color:
                      isOnline ? Colors.greenAccent : const Color(0xFFFC83AF)),
            ),
          )
        ]));
  }
}

// 主页内容
class HomeMainList extends StatelessWidget {
  const HomeMainList({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return ListView(
      children: [
        const Text(
          "你好，阁下！",
          style: TextStyle(
              fontFamily: 'Sweet', fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(
          '${today.year}年${today.month}月${today.day}日',
          style: const TextStyle(
              fontFamily: 'Sweet',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC4D7)),
        ),
        const RobotInfo(),
        const WeatherInfoCard(),
        const SizedBox(
          height: 10,
        ),
        const FunctionInfoList()
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
    MyAppData myAppData = Provider.of<MyAppData>(context);
    String name = myAppData.userName;
    return Card(
      elevation: 20,
      color: Colors.white,
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
              image: DecorationImage(
                  // image: AssetImage("assets/images/Elysia.jpg"),
                  image: NetworkImage(
                      "http://q1.qlogo.cn/g?b=qq&nk=${myAppData.userId}&s=5"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20), //设置盒子的圆角
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontFamily: 'Sweet', fontSize: 30),
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
                width: MediaQuery.of(context).size.width - 220,
                child: const Divider(thickness: 2),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
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
  String getDays() {
    // 获取当前日期
    final today = DateTime.now();

    // 获取星期几
    final weekdayIndex = today.weekday;

    // 星期几的中文表示
    final weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];

    // 计算当前是星期几
    final currentWeekday = weekdays[weekdayIndex - 1];
    return "${today.year}年 ${today.month}月${today.day}日 $currentWeekday";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final MyAppData myAppData = Provider.of<MyAppData>(context);
    bool isWeatherEnable = myAppData.isWeatherEnable;
    String weatherCode =
        "${myAppData.weatherNowDay["code"]}${myAppData.weather3Day["code"]}";
    String weather = weatherCode != "11" &&
            myAppData.weatherNowDay["now"] != null
        ? "今天·${myAppData.weatherNowDay["now"]["temp"]}℃·${myAppData.weatherNowDay["now"]["text"]}"
        : "天气获取失败";
    List? weather3Days = weatherCode != "11" &&
            myAppData.weather3Day["daily"] != null
        ? [myAppData.weather3Day["daily"][1], myAppData.weather3Day["daily"][2]]
        : null;

    int tomorrowTemperature = weather3Days != null
        ? (int.parse(weather3Days[0]["tempMax"]) +
                int.parse(weather3Days[0]["tempMin"])) ~/
            2
        : 0;
    int afterTomorrowTemperature = weather3Days != null
        ? (int.parse(weather3Days[1]["tempMax"]) +
                int.parse(weather3Days[1]["tempMin"])) ~/
            2
        : 0;
    if (weatherCode == "11") {
      if (isWeatherEnable) {
        isWeatherEnable = false;
        myAppData.setWeatherEnable(isWeatherEnable);
      }
      notificationToast(text: myAppData.weatherNowDay["msg"], level: 3);
    }

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
            child: Stack(
              children: [
                SizedBox(
                    height: 100,
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
                                      image:
                                          AssetImage("assets/images/mio.jpg"),
                                      fit: BoxFit.cover),
                                  borderRadius:
                                      BorderRadius.circular(20), //设置盒子的圆角
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
                                              weather,
                                              style: TextStyle(
                                                fontSize: width > 400 ? 25 : 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              getDays(),
                                              style: const TextStyle(
                                                  fontFamily: 'Sweet',
                                                  fontSize: 13,
                                                  color: Colors.black54),
                                            ),
                                            Container(
                                              height: 18,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color:
                                                      const Color(0xFF888888)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "明天 $tomorrowTemperature℃",
                                                      style: const TextStyle(
                                                          fontFamily: 'Sweet',
                                                          fontSize: 8,
                                                          color: Colors.white)),
                                                  Text(
                                                      "后天 $afterTomorrowTemperature℃",
                                                      style: const TextStyle(
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
                    )),
                isWeatherEnable
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          isWeatherEnable = true;
                          myAppData.setWeatherEnable(isWeatherEnable);
                          myAppData.updateWeather();
                        },
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: Stack(
                              children: [
                                const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.cloud_outlined,
                                      size: 55,
                                      color: Color(0xFFFFC4D7),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "天气卡片",
                                          style: TextStyle(
                                              fontFamily: 'Sweet',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Color(0xFFFBBDCF)),
                                        ),
                                        Text(
                                          "点击开启后可查看未来天气",
                                          style: TextStyle(
                                              fontFamily: 'Sweet',
                                              fontSize: 15,
                                              color: Color(0xFFFFC4D7)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFEEDF0),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.chevron_right,
                                          size: 20,
                                        ),
                                        color: const Color(0xFFFF91AF),
                                        onPressed: () {},
                                      ),
                                    ))
                              ],
                            )))
              ],
            )));
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
                                      WidgetStateProperty.resolveWith(
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
