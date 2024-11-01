// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import '../data/my_app_data.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../tools/deep_copy.dart';
import '../widgets/toast.dart';

class PluginPage extends StatelessWidget {
  const PluginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFFF1F3F7),
        surfaceTintColor: Colors.transparent,
        title: const Text("插件",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: const PluginPageBody(),
    );
  }
}

class MoreActionFloatingActionButton extends StatefulWidget {
  const MoreActionFloatingActionButton({super.key});

  @override
  State<MoreActionFloatingActionButton> createState() =>
      _MoreActionFloatingActionButtonState();
}

class _MoreActionFloatingActionButtonState
    extends State<MoreActionFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, right: 30),
      height: 70,
      width: 70,
      decoration: const BoxDecoration(
          color: Color(0xFFF784A7),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Color(0xFFF784A7), blurRadius: 15)]),
      child: IconButton(
        icon: const Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }
}

class PluginPageBody extends StatefulWidget {
  const PluginPageBody({super.key});

  @override
  State<PluginPageBody> createState() => _PluginPageBodyState();
}

class _PluginPageBodyState extends State<PluginPageBody> {
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pageList = [const PluginsStatus(), const PluginList()];
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF1F3F7),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainPluginSwitch(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        _selectIndex = 0;
                      });
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      // 禁用点击高亮
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // 减少点击区域
                      visualDensity: VisualDensity.compact, // 减少内部填充
                    ),
                    child: Text(
                      "状态",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Sweet",
                          color:
                              _selectIndex == 0 ? Colors.black : Colors.grey),
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _selectIndex = 1;
                      });
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      // 禁用点击高亮
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // 减少点击区域
                      visualDensity: VisualDensity.compact, // 减少内部填充
                    ),
                    child: Text("列表",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Sweet",
                            color: _selectIndex == 1
                                ? Colors.black
                                : Colors.grey)))
              ],
            ),
            Stack(
              children: [
                const Divider(),
                AnimatedPositioned(
                    curve: Curves.easeOut,
                    top: 2,
                    left: _selectIndex == 0 ? 3 : 70,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      width: 60,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFFF91AE),
                        // boxShadow: const [
                        //   BoxShadow(
                        //       color: Color(0xFFFF91AE), blurRadius: 3)
                        // ]
                      ),
                    ))
              ],
            ),
            pageList[_selectIndex],
          ],
        ),
      ),
      if (_selectIndex == 1)
        const Align(
          alignment: Alignment.bottomRight,
          child: MoreActionFloatingActionButton(),
        )
    ]);
  }
}

class MainPluginSwitch extends StatefulWidget {
  const MainPluginSwitch({super.key});

  @override
  State<MainPluginSwitch> createState() => _MainSwitchState();
}

class _MainSwitchState extends State<MainPluginSwitch> {
  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);
    bool pluginSwitch = myAppData.mainPluginSwitch;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: pluginSwitch ? const Color(0xFFF784A7) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: pluginSwitch
                    ? const Color(0xFFF784A7).withOpacity(0.5)
                    : Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: -5,
                offset: const Offset(0, 12)),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "插件总开关",
              style: TextStyle(
                  color: pluginSwitch
                      ? Colors.white
                      : Colors.black.withOpacity(0.6),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              pluginSwitch ? "全部插件已加载..." : "插件已关闭...",
              style: TextStyle(
                color: pluginSwitch ? Colors.white70 : Colors.black45,
              ),
            )
          ]),
          Switch(
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFFFC6590),
              inactiveThumbColor: const Color(0xFFFF91AE),
              inactiveTrackColor:
                  pluginSwitch ? Colors.white : const Color(0xFFF1F1F1),
              trackOutlineColor: WidgetStateProperty.resolveWith((Set states) {
                return Colors.transparent; // Use the default color.
              }),
              value: pluginSwitch,
              onChanged: (bool value) {
                setState(() {
                  // 更新状态
                  myAppData.setMainPluginSwitchState(value);
                });
              })
        ],
      ),
    );
  }
}

class PluginLoadingChart extends StatelessWidget {
  const PluginLoadingChart({super.key});

  bool isOnlyOneElement(List<int> list) {
    int nonZeroCount = 0;

    for (var element in list) {
      if (element != 0) {
        nonZeroCount++;
        if (nonZeroCount > 1) {
          return false; // 如果发现不止一个非零元素，立即返回false
        }
      }
    }

    // 如果非零元素数量恰好为1，则返回true
    return nonZeroCount == 1;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 2 - 30;
    List<int> number = [8, 2, 1, 1];
    int total = number.reduce((a, b) => a + b);

    bool isFull = isOnlyOneElement(number);

    List<double> values =
        List.generate(number.length, (index) => number[index] / total);
    List<List<Color>> valueColors = [
      [const Color(0xFF18B4E5), const Color(0xFF58D5FB)],
      [const Color(0xFF2AEDD8), const Color(0xFF6DF4E7)],
      [const Color(0xFFEE873D), const Color(0xFFF6A56C)],
      [const Color(0xFFD977C0), const Color(0xFFE8A5D7)],
    ];

    const List<String> labels = ["高耗时", "中高耗时", "中耗时", "低耗时"];
    return Container(
        padding: const EdgeInsets.all(20),
        height: 310,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: const [
              BoxShadow(
                  color: Color(0xFFF784A7),
                  blurRadius: 30,
                  spreadRadius: -20,
                  offset: Offset(5, 10))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "性能",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Sweet",
                  ),
                ),
                Container(
                  width: 120,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color(
                        0xFFF0F0F0,
                      ).withOpacity(0.6),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      )),
                  child: const Text(
                    "统计插件加载耗时",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                width: width,
                height: width,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: CustomPaint(
                  size: const Size(100, 100),
                  painter: _CircularGradientPainter(
                      values: values, valueColors: valueColors, isFull: isFull),
                ),
              ),
              Expanded(
                  child: Container(
                height: 180,
                padding: const EdgeInsets.only(top: 25),
                // color: Colors.black,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: labels
                      .map((e) => Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: valueColors[labels.indexOf(e)][0],
                                    boxShadow: [
                                      BoxShadow(
                                        color: valueColors[labels.indexOf(e)]
                                            [0],
                                        // spreadRadius: 2,
                                        blurRadius: 10,
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                  )),
                              Text(
                                e,
                                style: const TextStyle(
                                  fontFamily: "Sweet",
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("${number[labels.indexOf(e)]}个",
                                  style: const TextStyle(
                                      fontFamily: "Sweet", fontSize: 15))
                            ],
                          ))
                      .toList(),
                ),
              ))
            ])
          ],
        ));
  }
}

class _CircularGradientPainter extends CustomPainter {
  List<double> values; // 目标进度
  List<List<Color>> valueColors;
  bool isFull = false;

  _CircularGradientPainter(
      {required this.values, required this.valueColors, this.isFull = false});

  @override
  void paint(Canvas canvas, Size size) {
    double space = isFull ? 0 : 0.5;
    // 绘制底层阴影
    double startAngle = -math.pi / 2;

    for (int index = 0; index < values.length; index++) {
      if (values[index] == 0) {
        continue;
      }
      final Paint valuePaintShadow = Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30) // 10 是模糊半径
        ..shader = LinearGradient(
          begin: const Alignment(-1, -1),
          end: const Alignment(1, 1),
          colors: valueColors[index],
        ).createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 17.0;
      final Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2 + valuePaintShadow.strokeWidth / 4,
      );

      canvas.drawArc(rect, startAngle, 2 * math.pi * values[index] - 0.3, false,
          valuePaintShadow);

      startAngle += 2 * math.pi * values[index];
    }

    // 绘制边缘黑色阴影
    final Paint shadowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15) // 10 是模糊半径

      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // 改变颜色并绘制特定角度的边框
    shadowPaint.strokeCap = StrokeCap.round;
    double angle = 2.2;
    double deltaAngle = math.pi; // 每段边框覆盖45度
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2 - 45),
      angle,
      deltaAngle,
      false,
      shadowPaint,
    );

    angle = -0.3;
    deltaAngle = 2.4;
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2 + 10),
      angle,
      deltaAngle,
      false,
      shadowPaint,
    );

    // 背景
    final Paint backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 60.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 5);

    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 - 10,
    );

    canvas.drawArc(rect, 0, 2 * math.pi, false, backgroundPaint);

    startAngle = -math.pi / 2;
    for (int index = 0; index < values.length; index++) {
      if (values[index] == 0) {
        continue;
      }
      final Paint valuePaint = Paint()
        // ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10) // 10 是模糊半径
        ..shader = LinearGradient(
          begin: const Alignment(-1, -1),
          end: const Alignment(1, 1),
          colors: valueColors[index],
        ).createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15.0;

      final Paint valuePaintShadow = Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10) // 10 是模糊半径
        ..shader = LinearGradient(
          begin: const Alignment(-1, -1),
          end: const Alignment(1, 1),
          colors: valueColors[index],
        ).createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15.0;
      final Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2 - valuePaint.strokeWidth / 2,
      );

      canvas.drawArc(
          rect,
          startAngle,
          math.max(2 * math.pi * values[index] - space, 0.05),
          false,
          valuePaintShadow);
      canvas.drawArc(
          rect,
          startAngle,
          math.max(2 * math.pi * values[index] - space, 0.05),
          false,
          valuePaint);
      startAngle += 2 * math.pi * values[index];
    }
  }

  @override
  bool shouldRepaint(_CircularGradientPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

class PluginList extends StatefulWidget {
  const PluginList({super.key});

  @override
  State<PluginList> createState() => _PluginListState();
}

class _PluginListState extends State<PluginList> {
  List<Widget> generateWidgetsFromMap(Map map) {
    return map.entries.map((entry) {
      if (entry.value == null) {
        return BasePluginCard(
          pluginKey: entry.key,
          pluginName: entry.key,
          pluginImage: const AssetImage("assets/images/Elysia.jpg"),
          pluginDesc: "插件读取错误",
          pluginVersion: "null",
          pluginAuthor: "null",
          pluginState: false,
          pluginData: const {},
        );
      }
      Map data = entry.value;
      return BasePluginCard(
          pluginKey: entry.key,
          pluginName: data["name"],
          pluginImage: const AssetImage("assets/images/Elysia.jpg"),
          pluginDesc: data["description"],
          pluginVersion: data["version"],
          pluginAuthor: data["author"],
          pluginState: data["setting"]["load"],
          pluginData: data);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);
    Map pluginsData = myAppData.pluginsData;
    if (pluginsData.isEmpty) {
      myAppData.getPluginsData();
    }
    return Selector<MyAppData, Map>(
        selector: (_, myAppData) => myAppData.pluginsData,
        builder: (context, pluginsData, _) {
          return Expanded(
              child: Container(
                  color: const Color(0xFFF1F3F7),
                  child: ListView(
                    children: generateWidgetsFromMap(pluginsData),
                  )));
        });
  }
}

class BasePluginCard extends StatefulWidget {
  final String pluginKey;
  final String pluginName;
  final ImageProvider pluginImage;
  final String pluginDesc;
  final String pluginVersion;
  final String pluginAuthor;
  final bool pluginState;
  final Map pluginData;

  const BasePluginCard({
    super.key,
    required this.pluginName,
    required this.pluginImage,
    required this.pluginDesc,
    required this.pluginVersion,
    required this.pluginAuthor,
    required this.pluginState,
    required this.pluginKey,
    required this.pluginData,
  });

  @override
  State<BasePluginCard> createState() => _BasePluginCardState();
}

class _BasePluginCardState extends State<BasePluginCard> {
  bool pluginState = false;

  // 警告等级
  int level = 2;
  late Map pluginSettingData;
  late Map rowSettingData;

  @override
  void initState() {
    super.initState();
    pluginSettingData = widget.pluginData;
    rowSettingData = deepCopy(widget.pluginData);
    pluginState = widget.pluginState;
    if (widget.pluginVersion != "null") {
      controller.text = pluginSettingData["setting"]["priority"].toString();
      controllerRuntimeThreshold.text = pluginSettingData["developer_setting"]
              ["runtime_threshold"]
          .toString();
    } else {
      controller.text = "0";
      controllerRuntimeThreshold.text = "0";
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controllerRuntimeThreshold.dispose();
    super.dispose();
  }

  TextEditingController controller = TextEditingController();
  TextEditingController controllerRuntimeThreshold = TextEditingController();

  void update(newDate) async {
    MyAppData myAppData = Provider.of<MyAppData>(context, listen: false);
    bool state = await myAppData.updatePlugin(newDate);
    if (state) {
      notificationToast(text: "保存成功", level: 2);
    } else {
      setState(() {
        pluginSettingData = rowSettingData;
      });
      notificationToast(text: "保存失败", level: 1);
    }
  }

  // 展示详情页
  void showDetails(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (buildContext) {
          final List<String> events = ['message', 'notice', 'request'];
          final List<String> options = ['消息事件', '通知事件', '请求事件'];
          List<String> selectOptions = [];
          final List<IconData> myIcons = [
            Icons.message_outlined,
            Icons.notifications_outlined,
            Icons.request_page_outlined
          ];

          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            //   单个设置参数组件
            Widget settingCard(
                {required String setting,
                required String description,
                bool isDeveloperSetting = false}) {
              String settingKey =
                  isDeveloperSetting ? "developer_setting" : "setting";

              if (pluginSettingData[settingKey][setting] is List) {
                for (String event in pluginSettingData[settingKey][setting]) {
                  if (events.contains(event)) {
                    selectOptions.add(options[events.indexOf(event)]);
                  }
                }

                return SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                            runSpacing: 5,
                            spacing: 5,
                            children: List.generate(options.length, (index) {
                              bool isSelect =
                                  selectOptions.contains(options[index]);
                              return IntrinsicWidth(
                                  child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: isSelect
                                              ? const Color(0xFFFBA3AE)
                                              : const Color(0xFFE5E2EA),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextButton(
                                          style: ButtonStyle(
                                            overlayColor:
                                                WidgetStateProperty.all(
                                                    Colors.transparent),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (isSelect) {
                                                selectOptions
                                                    .remove(options[index]);
                                              } else {
                                                selectOptions
                                                    .add(options[index]);
                                              }
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(myIcons[index],
                                                  color: isSelect
                                                      ? Colors.white
                                                      : Colors.black),
                                              Text(options[index],
                                                  style: TextStyle(
                                                      color: isSelect
                                                          ? Colors.white
                                                          : Colors.black))
                                            ],
                                          ))));
                            }))
                      ],
                    ));
              } else if (pluginSettingData[settingKey][setting] is int ||
                  pluginSettingData[settingKey][setting] is double) {
                late TextEditingController myController;
                if (setting == "priority") {
                  myController = controller;
                } else {
                  myController = controllerRuntimeThreshold;
                }

                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                          width: 70,
                          height: 40,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: myController,
                            // 预填充文本
                            style: const TextStyle(fontSize: 20),
                            keyboardType: TextInputType.number,
                            // 使用数字键盘
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ], // 只允许输入数字
                          ))
                      // 更新
                    ]);
              } else if (pluginSettingData[settingKey][setting] is bool) {
                bool settingSwitch = pluginSettingData[settingKey][setting];
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Switch(
                          activeColor: Colors.white,
                          activeTrackColor: const Color(0xFFF7C1C8),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: settingSwitch
                              ? Colors.white
                              : const Color(0xFFF1F1F1),
                          trackOutlineColor:
                              WidgetStateProperty.resolveWith((Set states) {
                            return settingSwitch
                                ? const Color(0xFFFBA3AF)
                                : const Color(0xFFD6D5DB);
                          }),
                          value: settingSwitch,
                          onChanged: (bool value) {
                            setState(() {
                              // 更新状态
                              settingSwitch = value;
                              pluginSettingData[settingKey][setting] = value;
                            });
                          })
                    ]);
              } else {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      IntrinsicWidth(
                          child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "    ${pluginSettingData[settingKey][setting]}    ",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              )))
                    ]);
              }
            }

            return AlertDialog(
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.white54,
                contentPadding: const EdgeInsets.all(10),
                content: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: SizedBox(
                            width: 400,
                            height: 500,
                            child: Stack(children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ListView(children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      "  通用",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IntrinsicHeight(
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Column(
                                            children: [
                                              settingCard(
                                                  setting: 'load',
                                                  description: '是否开启'),
                                              const Divider(),
                                              settingCard(
                                                  setting: 'priority',
                                                  description: '运行优先级'),
                                              const Divider(),
                                              settingCard(
                                                  setting:
                                                      'prevent_other_plugins',
                                                  description: '阻止其他插件运行'),
                                              const Divider(),
                                              settingCard(
                                                setting: 'event',
                                                description: '监听事件',
                                              ),
                                              const Divider(),
                                              settingCard(
                                                  setting: 'callback_name',
                                                  description: '回调函数名'),
                                            ],
                                          ))),
                                  const Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 10, top: 20),
                                      child: Text(
                                        "  开发者设置",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  IntrinsicHeight(
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                        children: [
                                          settingCard(
                                              setting: 'count_runtime',
                                              description: '是否记录运行时间',
                                              isDeveloperSetting: true),
                                          const Divider(),
                                          settingCard(
                                              setting: 'runtime_threshold',
                                              description: '运行时间阈值',
                                              isDeveloperSetting: true),
                                          const Divider(),
                                          settingCard(
                                              setting: 'allow_high_time_cost',
                                              description: '是否允许高耗时操作',
                                              isDeveloperSetting: true),
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                              Container(
                                  width: double.infinity,
                                  height: 70,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white70,
                                          Colors.white70,
                                          Colors.white10
                                        ]),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        " 插件详情",
                                        style: TextStyle(
                                          // fontFamily: "Sweet",
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF7C1C8),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                            onPressed: () {
                                              Map newDate = {
                                                "callback_name":
                                                    pluginSettingData["setting"]
                                                        ["callback_name"],
                                                "setting_data":
                                                    pluginSettingData
                                              };

                                              update(newDate);
                                            },
                                            icon: const Icon(
                                              Icons.save,
                                              color: Colors.white,
                                            )),
                                      )
                                    ],
                                  ))
                            ])))));
          });
        }).then((_) {
      pluginSettingData = deepCopy(rowSettingData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.pluginVersion != "null") {
            showDetails(context);
          }
        },
        child: IntrinsicHeight(
            child: Container(
                // height: 140,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: pluginState
                      ? const LinearGradient(
                          colors: [Color(0xFFFFB4CA), Color(0xFFFFB4CA)],
                        )
                      : const LinearGradient(
                          colors: [Colors.white, Colors.white70],
                        ),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFF784A7),
                        blurRadius: 30,
                        spreadRadius: pluginState ? -18 : -20,
                        offset: const Offset(5, 10))
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: widget.pluginImage,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.pluginName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Sweet",
                                        color: pluginState
                                            ? Colors.white
                                            : Colors.black)),
                                Text(widget.pluginAuthor,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Sweet",
                                        color: pluginState
                                            ? Colors.white
                                            : Colors.grey)),
                                Text("版本${widget.pluginVersion}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Sweet",
                                        color: pluginState
                                            ? Colors.white
                                            : Colors.grey)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(widget.pluginDesc,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Sweet",
                              color: pluginState ? Colors.white : Colors.grey,
                            )),
                      ],
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 90,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (level == 1)
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.amberAccent,
                                  size: 30,
                                ),
                              if (level == 2)
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              Switch(
                                  activeColor: Colors.white,
                                  activeTrackColor: const Color(0xFFFF7EA1),
                                  inactiveThumbColor: const Color(0xFFFF91AE),
                                  inactiveTrackColor: Colors.white,
                                  trackOutlineColor:
                                      WidgetStateProperty.resolveWith(
                                          (Set states) {
                                    return Colors
                                        .transparent; // Use the default color.
                                  }),
                                  value: pluginState,
                                  onChanged: (bool value) {
                                    setState(() {
                                      if (widget.pluginData.isNotEmpty) {
                                        pluginState = value;
                                      }
                                    });
                                  }),
                            ],
                          ),
                        )),
                  ],
                ))));
  }
}

class Score extends StatefulWidget {
  const Score({super.key});

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  int score = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white70],
            ),
            boxShadow: const [
              BoxShadow(
                  color: Color(0xFFF784A7),
                  blurRadius: 30,
                  spreadRadius: -20,
                  offset: Offset(5, 10))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                score.toString(),
                style:
                    const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 20),
                child: Text(
                  "分",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: 50,
              width: 120,
              // alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   color: const Color(0xFFFF91AE),
              //   borderRadius: BorderRadius.circular(50),
              // ),
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: const WidgetStatePropertyAll(0),
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFFFF91AE)),
                  overlayColor: const WidgetStatePropertyAll(Colors.white10),
                ),
                onPressed: () {},
                child: const Text(
                  "插件重载",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ));
  }
}

class TotalCard extends StatelessWidget {
  const TotalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xFFFF91AE),
                          blurRadius: 30,
                          spreadRadius: -15,
                          offset: Offset(5, 10))
                    ]),
                child: const Column(
                  children: [
                    Text(
                      "调用数",
                      style: TextStyle(
                          letterSpacing: 8,
                          fontSize: 15,
                          color: Color(0xFF565D78)),
                    ),
                    Text(
                      "17%",
                      style: TextStyle(
                          fontSize: 30,
                          color: Color(0xFF6A6BF3),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Increase",
                      style: TextStyle(fontSize: 12, color: Color(0xFFBAC2CD)),
                    ),
                    Expanded(
                        child: SizedBox(
                      height: 80,
                      child: LoadingLineChart(),
                    )),
                    Text(
                      "ACTIVE",
                      style: TextStyle(
                        color: Color(0xFF6A6BF3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xFFFF91AE),
                          blurRadius: 30,
                          spreadRadius: -15,
                          offset: Offset(5, 10))
                    ]),
                child: const StableState(),
              ))
        ],
      ),
    );
  }
}

class LoadingLineChart extends StatefulWidget {
  const LoadingLineChart({super.key});

  @override
  State<LoadingLineChart> createState() => _LoadingLineChartState();
}

class _LoadingLineChartState extends State<LoadingLineChart> {
  Color mainColor = Colors.deepPurpleAccent;

  List<FlSpot> realisticData = const [
    FlSpot(0, 3),
    FlSpot(1, 2),
    FlSpot(2, 5),
    FlSpot(3, 5),
    FlSpot(4, 3),
    FlSpot(5, 2),
    FlSpot(6, 3),
  ];

  List<FlSpot> predictedData = const [
    FlSpot(6, 3),
    FlSpot(7, 3),
    FlSpot(8, 2),
    FlSpot(9, 5),
    FlSpot(10, 5),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      mainData(),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: const FlGridData(
        show: false,
      ),
      titlesData: const FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 7,
      lineBarsData: [
        LineChartBarData(
          spots: realisticData,
          isCurved: false,
          color: mainColor,
          barWidth: 3,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [mainColor.withOpacity(0.3), Colors.white]),
          ),
        ),
        LineChartBarData(
          spots: predictedData,
          isCurved: false,
          color: mainColor,
          barWidth: 3,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [mainColor.withOpacity(0.3), Colors.white])),
          dashArray: [5, 5],
        ),
      ],
    );
  }
}

class StableState extends StatefulWidget {
  const StableState({super.key});

  @override
  State<StableState> createState() => _StableStateState();
}

class _StableStateState extends State<StableState> {
  bool isRunning = true;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        "稳定性",
        style:
            TextStyle(letterSpacing: 8, fontSize: 15, color: Color(0xFF565D78)),
      ),
      const Text(
        "100%",
        style: TextStyle(
            fontSize: 30,
            color: Color(0xFFF85C2D),
            fontWeight: FontWeight.bold),
      ),
      const Text(
        "Stable",
        style: TextStyle(fontSize: 12, color: Color(0xFFBAC2CD)),
      ),
      Expanded(
          flex: 1,
          child: SizedBox(
              child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(
              value: isRunning ? null : 1,
              color: const Color(0xFFF85C2D),
              strokeWidth: 8,
            ),
            Icon(
              isRunning ? Icons.gpp_good_outlined : Icons.gpp_maybe_outlined,
              color: const Color(0xFFF85C2D),
            )
          ]))),
      const Text(
        "ACTIVE",
        style: TextStyle(
          color: Color(0xFFF85C2D),
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }
}

class AdviceInfo extends StatelessWidget {
  const AdviceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0xFFFF91AE),
                blurRadius: 30,
                spreadRadius: -15,
                offset: Offset(5, 10))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "优化建议",
          style: TextStyle(
            fontSize: 25,
            fontFamily: "Sweet",
          ),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // border: Border(
            //     bottom:
            //         BorderSide(color: Colors.grey.withOpacity(0.5), width: 3),
            //     right:
            //         BorderSide(color: Colors.grey.withOpacity(0.5), width: 3)),
            color: const Color(0xFFFF91AE).withOpacity(0.5),
            boxShadow: const [
              BoxShadow(
                  color: Color(0xFFFF91AE), blurRadius: 30, spreadRadius: -10)
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                  height: 60,
                  width: 10,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.redAccent,
                          blurRadius: 10,
                          spreadRadius: 0,
                        )
                      ])),
              const SizedBox(
                width: 20,
              ),
              const Text(
                "关闭高耗时插件",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            // border: Border(
            //     bottom:
            //         BorderSide(color: Colors.grey.withOpacity(0.5), width: 3),
            //     right:
            //         BorderSide(color: Colors.grey.withOpacity(0.5), width: 3)),
            color: const Color(0xFFFF91AE).withOpacity(0.5),
            boxShadow: const [
              BoxShadow(
                  color: Color(0xFFFF91AE), blurRadius: 30, spreadRadius: -10)
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                  height: 60,
                  width: 10,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.redAccent,
                          blurRadius: 10,
                          spreadRadius: 0,
                        )
                      ])),
              const SizedBox(
                width: 20,
              ),
              const Text(
                "清除插件缓存",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ]),
    );
  }
}

class PluginsStatus extends StatelessWidget {
  const PluginsStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: const Color(0xFFF1F3F7),
      child: ListView(
        children: const [
          Score(),
          TotalCard(),
          PluginLoadingChart(),
          AdviceInfo(),
          SizedBox(
            height: 30,
          )
        ],
      ),
    ));
  }
}
