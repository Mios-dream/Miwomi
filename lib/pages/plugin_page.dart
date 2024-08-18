// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/my_app_data.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

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
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
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
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
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
              trackOutlineColor:
                  MaterialStateProperty.resolveWith((Set states) {
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

  @override
  Widget build(BuildContext context) {
    int total = 10;
    List<int> number = [4, 3, 2, 1];

    List<double> values =
        List.generate(number.length, (index) => number[index] / total);
    List<List<Color>> valueColors = [
      [const Color(0xFF18B4E5), const Color(0xFF58D5FB)],
      [const Color(0xFF2AEDD8), const Color(0xFF6DF4E7)],
      [const Color(0xFFEE873D), const Color(0xFFF6A56C)],
      [const Color(0xFFD977C0), const Color(0xFFE8A5D7)],
    ];

    const List<String> labels = ["5s>", "3s>", "1s>", "0s>"];
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
            const Text(
              "性能",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Sweet",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: CustomPaint(
                  size: const Size(100, 100),
                  painter: _CircularGradientPainter(
                    values: values,
                    valueColors: valueColors,
                  ),
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
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("${number[labels.indexOf(e)]}个",
                                  style: const TextStyle(
                                      fontFamily: "Sweet", fontSize: 20))
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
  late List<double> values; // 目标进度
  late List<List<Color>> valueColors;

  _CircularGradientPainter({required this.values, required this.valueColors});

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制底层阴影
    double startAngle = -math.pi / 2;

    for (int index = 0; index < values.length; index++) {
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
          math.max(2 * math.pi * values[index] - 0.5, 0.05),
          false,
          valuePaintShadow);
      canvas.drawArc(rect, startAngle,
          math.max(2 * math.pi * values[index] - 0.5, 0.05), false, valuePaint);
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Container(
      color: const Color(0xFFF1F3F7),
      height: height - 278,
      child: ListView(
        children: const [
          BasePluginCard(
            pluginName: '词云插件',
            pluginImage: AssetImage("assets/images/Elysia.jpg"),
            pluginDesc: '词云插件可以生成词云，用于展示文本中的关键词和频率',
            pluginVersion: '1.0',
            pluginAuthor: '然飞',
          ),
          BasePluginCard(
            pluginName: '词云插件',
            pluginImage: AssetImage("assets/images/Elysia.jpg"),
            pluginDesc: '词云插件可以生成词云，用于展示文本中的关键词和频率',
            pluginVersion: '1.0',
            pluginAuthor: '然飞',
          ),
          BasePluginCard(
            pluginName: '词云插件',
            pluginImage: AssetImage("assets/images/Elysia.jpg"),
            pluginDesc: '词云插件可以生成词云，用于展示文本中的关键词和频率',
            pluginVersion: '1.0',
            pluginAuthor: '然飞',
          )
        ],
      ),
    );
  }
}

class BasePluginCard extends StatefulWidget {
  final String pluginName;
  final ImageProvider pluginImage;
  final String pluginDesc;
  final String pluginVersion;
  final String pluginAuthor;

  const BasePluginCard(
      {super.key,
      required this.pluginName,
      required this.pluginImage,
      required this.pluginDesc,
      required this.pluginVersion,
      required this.pluginAuthor});

  @override
  State<BasePluginCard> createState() => _BasePluginCardState();
}

class _BasePluginCardState extends State<BasePluginCard> {
  bool pluginState = true;
  int level = 2;

  // // 展示详情页
  // void _showBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: const EdgeInsets.all(20.0),
  //         height: 200.0, // 可以根据需要调整高度
  //         child: Column(
  //           children: <Widget>[
  //             const Text('Bottom Sheet Content'),
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // 关闭Bottom Sheet
  //               },
  //               child: const Text('Close'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 140,
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
                                color:
                                    pluginState ? Colors.white : Colors.black)),
                        Text(widget.pluginAuthor,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Sweet",
                                color:
                                    pluginState ? Colors.white : Colors.grey)),
                        Text("版本${widget.pluginVersion}",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Sweet",
                                color:
                                    pluginState ? Colors.white : Colors.grey)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(widget.pluginDesc,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Sweet",
                        color: pluginState ? Colors.white : Colors.grey,
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
            Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 90,
                  height: 50,
                  child: Row(
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
                              MaterialStateProperty.resolveWith((Set states) {
                            return Colors.transparent; // Use the default color.
                          }),
                          value: pluginState,
                          onChanged: (bool value) {
                            setState(() {
                              pluginState = value;
                            });
                          }),
                    ],
                  ),
                )),
          ],
        ));
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
            Container(
              height: 50,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFF91AE),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextButton(
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
                      "ACTION",
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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Container(
      color: const Color(0xFFF1F3F7),
      height: height - 278,
      child: ListView(
        children: const [
          SizedBox(
            height: 20,
          ),
          Score(),
          TotalCard(),
          PluginLoadingChart(),
          AdviceInfo(),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
