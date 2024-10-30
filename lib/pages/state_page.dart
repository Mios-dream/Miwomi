import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../tools/hex_color_to_colors.dart';
import '../data/my_app_data.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class SatePage extends StatelessWidget {
  const SatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: statePageBar(context),
      body: const StatePageBody(),
    );
  }
}

AppBar statePageBar(BuildContext context) {
  return AppBar(
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
    title: const Text("状态",
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
    centerTitle: true,
  );
}

class StatePageBody extends StatelessWidget {
  const StatePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);
    return Container(
      color: const Color(0xFFF1F3F7),
      alignment: Alignment.center,
      child: ListView(children: [
        const MainSwitch(),
        ComputerInfoCard(
          address: myAppData.address,
        ),
        const RomAndMemoryCard(),
        const RunSateCard(),
        const LogInfoCard(),
        DetailedCoreInformation(address: myAppData.address),
      ]),
    );
  }
}

class MainSwitch extends StatefulWidget {
  const MainSwitch({super.key});

  @override
  State<MainSwitch> createState() => _MainSwitchState();
}

class _MainSwitchState extends State<MainSwitch> {
  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: myAppData.mainSwitch ? const Color(0xFFF784A7) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: myAppData.mainSwitch
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
              "总开关",
              style: TextStyle(
                  color: myAppData.mainSwitch
                      ? Colors.white
                      : Colors.black.withOpacity(0.6),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              myAppData.mainSwitch ? "任职中..." : "休息中...",
              style: TextStyle(
                color: myAppData.mainSwitch ? Colors.white70 : Colors.black45,
              ),
            )
          ]),
          Switch(
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFFFC6590),
              inactiveThumbColor: const Color(0xFFFF91AE),
              inactiveTrackColor:
                  myAppData.mainSwitch ? Colors.white : const Color(0xFFF1F1F1),
              trackOutlineColor: WidgetStateProperty.resolveWith((Set states) {
                return Colors.transparent; // Use the default color.
              }),
              value: myAppData.mainSwitch,
              onChanged: (bool value) {
                setState(() {
                  // 更新状态
                  myAppData.setMainSwitchState(value);
                });
              })
        ],
      ),
    );
  }
}

class ComputerInfoCard extends StatefulWidget {
  final String address;

  const ComputerInfoCard({super.key, required this.address});

  @override
  State<ComputerInfoCard> createState() => _CpuAndMemoryInfoCardState();
}

class _CpuAndMemoryInfoCardState extends State<ComputerInfoCard> {
  double cpu = 0;
  double memory = 0;
  double gpu = 0;
  Map computerUsedInfoData = {"cpu": 0, "memory": 0, "gpu": 0};

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Future getHttpRequest(String address) async {
    final response1 = await http.get(Uri.parse('$address/get_cpu_usage'));
    final response2 = await http.get(Uri.parse('$address/get_memory_usage'));
    final response3 =
        await http.get(Uri.parse('$address/get_nvidia_gpu_utilization'));

    if (response1.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response1.bodyBytes));
      computerUsedInfoData["cpu"] = data["cpu_usage"];
    }
    if (response2.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response2.bodyBytes));
      computerUsedInfoData["memory"] = data["memory_usage"];
    }
    if (response3.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response3.bodyBytes));
      computerUsedInfoData["gpu"] = data["utilization"];
    }
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        getHttpRequest(widget.address);
        cpu = computerUsedInfoData["cpu"] / 100;
        memory = computerUsedInfoData["memory"] / 100;
        gpu = computerUsedInfoData["gpu"] / 100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "性能",
          style: TextStyle(
            fontSize: 25,
            fontFamily: "Sweet",
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: BaseComputerInfoIndicator(
                name: "CPU",
                colors: [
                  HexColor.fromHex("#ff9a9e"),
                  HexColor.fromHex("#fecfef"),
                ],
                value: cpu,
              ),
            ),
            Expanded(
                flex: 1,
                child: BaseComputerInfoIndicator(
                  name: "Memory",
                  colors: [
                    HexColor.fromHex("#ff9a9e"),
                    HexColor.fromHex("#fecfef"),
                  ],
                  value: memory,
                )),
            Expanded(
                flex: 1,
                child: BaseComputerInfoIndicator(
                  name: "GPU",
                  colors: [
                    HexColor.fromHex("#ff9a9e"),
                    HexColor.fromHex("#fecfef"),
                  ],
                  value: gpu,
                ))
          ],
        ),
      ]),
    );
  }
}

class BaseComputerInfoIndicator extends StatefulWidget {
  final String name;
  final List<Color> colors;
  final double value;

  const BaseComputerInfoIndicator(
      {super.key, required this.name, required this.colors, this.value = 0.5});

  @override
  State<BaseComputerInfoIndicator> createState() => _BaseInfoState();
}

class _BaseInfoState extends State<BaseComputerInfoIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(10),
        width: 120,
        height: 120,
        child: CircularProgressBar(
          name: widget.name,
          value: widget.value,
          colors: [
            HexColor.fromHex("#ff9a9e"),
            HexColor.fromHex("#fecfef"),
          ],
        ),
      ),
    ]);
  }
}

class CircularProgressBar extends StatefulWidget {
  final double value; // 目标进度
  final List<Color> colors;
  final Duration duration;
  final String name;

  const CircularProgressBar({
    super.key,
    required this.value,
    required this.colors,
    this.duration = const Duration(seconds: 1),
    required this.name,
  });

  @override
  State<CircularProgressBar> createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<int> _textAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _textAnimation = IntTween(begin: 0, end: widget.value.toInt()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(CircularProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation =
          Tween<double>(begin: oldWidget.value, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );

      _textAnimation = IntTween(
              begin: (oldWidget.value * 100).toInt(),
              end: (widget.value * 100).toInt())
          .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // 假设我们的基准大小是 200 x 200
      const double baseSize = 120;
      final double scale = baseSize / constraints.biggest.shortestSide;

      final double effectiveScale = math.min(scale, 1.0);
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: effectiveScale,
            child: Stack(alignment: Alignment.center, children: [
              CustomPaint(
                size: const Size(100, 100),
                painter: _CircularGradientPainter(
                  value: _animation.value,
                  colors: widget.colors,
                ),
              ),
              Positioned(
                  top: 25,
                  child: Text(
                    widget.name,
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  )),
              Positioned(
                top: 40,
                child: Text(
                  _textAnimation.value.toStringAsFixed(0),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const Positioned(
                top: 60,
                left: 65,
                child: Text(
                  "%",
                  style: TextStyle(fontSize: 12),
                ),
              )
            ]),
          );
        },
      );
    });
  }
}

class _CircularGradientPainter extends CustomPainter {
  double value;
  List<Color> colors;

  _CircularGradientPainter({required this.value, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint valuePaint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1, -1),
        end: const Alignment(1, 1),
        colors: colors,
      ).createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    final Paint backgroundPaint = Paint()..color = Colors.grey.shade300;

    valuePaint.strokeCap = StrokeCap.round;
    valuePaint.style = PaintingStyle.stroke;
    valuePaint.strokeWidth = 12.0;

    backgroundPaint.style = PaintingStyle.stroke;
    backgroundPaint.strokeWidth = 12.0;

    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 - valuePaint.strokeWidth / 2,
    );
    canvas.drawArc(rect, 0, 2 * math.pi, false, backgroundPaint);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * value, false, valuePaint);
  }

  @override
  bool shouldRepaint(_CircularGradientPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

class RomAndMemoryCard extends StatelessWidget {
  const RomAndMemoryCard({super.key});

  final int usedRom = 20;
  final double usedDisk = 0.7;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "储存",
            style: TextStyle(
              fontSize: 25,
              fontFamily: "Sweet",
            ),
          ),
          Row(children: [
            Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          width: 70,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: Colors.black, width: 2)),
                          child: const Text("储存运行")),
                      Container(
                          padding: const EdgeInsets.all(15),
                          width: 180,
                          height: 160,
                          decoration: BoxDecoration(
                            // color: const Color(0xFFFBE88B),
                            color: const Color(0xFFFF91AE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 75,
                                  height: 55,
                                  child: GridView.count(
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      crossAxisCount: 4,
                                      children: List.generate(8, (index) {
                                        List colorIndex = [
                                          1,
                                          0,
                                          0,
                                          1,
                                          1,
                                          0,
                                          1,
                                          0
                                        ];
                                        return CircleAvatar(
                                          backgroundColor:
                                              colorIndex[index] == 1
                                                  ? const Color(0xFFFD6B6F)
                                                  : Colors.white,
                                          radius: 20,
                                        );
                                      })),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "内存占用",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white54),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 40,
                                      child: Stack(
                                        children: [
                                          Text(
                                            "$usedRom",
                                            style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Positioned(
                                            top: 20,
                                            left: 55,
                                            child: Text(
                                              "MB",
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                          // Positioned(
                                          //   top: 10,
                                          //   left: 80,
                                          //   child: Container(
                                          //       alignment: Alignment.center,
                                          //       width: 40,
                                          //       height: 25,
                                          //       decoration: BoxDecoration(
                                          //         color:
                                          //             const Color(0xFFFD6B6F),
                                          //         borderRadius:
                                          //             BorderRadius.circular(50),
                                          //       ),
                                          //       child: IconButton(
                                          //           onPressed: () {},
                                          //           icon: const Icon(
                                          //             // Icons.arrow_drop_down_rounded,
                                          //             Icons
                                          //                 .cleaning_services_rounded,
                                          //             color: Colors.white,
                                          //             size: 10,
                                          //           ))),
                                          // )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ]))
                    ])),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          width: 70,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: Colors.black, width: 2)),
                          child: const Text("储存空间")),
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: 180,
                        height: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFF404040),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FractionallySizedBox(
                                widthFactor: 0.7,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: (usedDisk * 100).toInt(),
                                        child: Container(
                                          height: 20,
                                          color: const Color(0xFF00C49B),
                                        )),
                                    Expanded(
                                        flex: 100 - (usedDisk * 100).toInt(),
                                        child: Container(
                                          height: 20,
                                          color: const Color(0xFF616262),
                                        )),
                                  ],
                                )),
                            const Text("占用较低。性能流畅",
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.grey,
                                )),
                            const SizedBox(
                              height: 35,
                            ),
                            const Text("已用",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                )),
                            SizedBox(
                              width: 100,
                              child: Stack(children: [
                                Text(
                                  "${(usedDisk * 100).toInt()}",
                                  style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Positioned(
                                    left: 40,
                                    top: 20,
                                    child: Text(
                                      "%",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ]),
                            )
                          ],
                        ),
                      )
                    ]))
          ])
        ]));
  }
}

class RunSateCard extends StatelessWidget {
  const RunSateCard({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> stateList = [
      {"state": "可用", "time": "2024-11-01", "reason": ""},
      {"state": "可用", "time": "2025-11-01", "reason": ""},
      {"state": "可用", "time": "2026-11-01", "reason": ""},
      {"state": "不可用", "time": "2026-11-01", "reason": ""},
      {"state": "不可用", "time": "2026-11-01", "reason": ""},
      {"state": "下线", "time": "2026-11-01", "reason": ""},
      {"state": "可用", "time": "2026-11-01", "reason": ""},
      {"state": "可用", "time": "2026-11-01", "reason": ""},
      {"state": "可用", "time": "2026-11-01", "reason": ""},
      {"state": "可用", "time": "2026-11-01", "reason": ""},
      {"state": "可用", "time": "2026-11-01", "reason": ""},
      {"state": "可用", "time": "2026-11-01", "reason": ""},
      {"state": "可用", "time": "2026-11-01", "reason": ""},
      {"state": "可用", "time": "2026-11-01", "reason": ""},
      {"state": "可用", "time": "2026-11-01", "reason": ""},
    ];
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "运行",
            style: TextStyle(
              fontSize: 25,
              fontFamily: "Sweet",
            ),
          ),
          const Text(
            "运行状态记录",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontFamily: "Sweet",
            ),
          ),
          Row(
              children: List.generate(
                  stateList.length,
                  (index) => Expanded(
                      flex: 1,
                      child: BasicStateContainer(
                        state: stateList[index]["state"],
                        time: stateList[index]["time"],
                        reason: stateList[index]["reason"],
                      )))),
          const Text(
            "核心运行状态良好...",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Sweet",
            ),
          ),
        ],
      ),
    );
  }
}

class BasicStateContainer extends StatefulWidget {
  final String? time;
  final String? state;
  final String? reason;

  const BasicStateContainer(
      {super.key,
      required this.time,
      required this.state,
      required this.reason});

  @override
  State<BasicStateContainer> createState() => _BasicStateContainerState();
}

class _BasicStateContainerState extends State<BasicStateContainer> {
  OverlayEntry? _overlayEntry;
  Timer? _timer;

  void _showTooltip() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: renderBox.localToGlobal(Offset.zero).dy - 90,
          left: renderBox.localToGlobal(Offset.zero).dx +
              renderBox.size.width / 2,
          child: Material(
            color: Colors.white,
            elevation: 10,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("状态:${widget.state}"),
                    Text("时间:${widget.time}"),
                    Text("原因:${widget.reason}"),
                  ],
                )),
          ),
        );
      },
    );
    overlay.insert(_overlayEntry!);
    _timer = Timer(const Duration(seconds: 2), () {
      _hideTooltip();
    });
  }

  void _hideTooltip() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _timer?.cancel();
  }

  Color stateColor() {
    if (widget.state == "可用") {
      return const Color(0xFF00C49B);
    } else if (widget.state == "不可用") {
      return const Color(0xFFFD6B6F);
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTooltip,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
        height: 40,
        color: stateColor(),
      ),
    );
  }
}

class LogInfoCard extends StatefulWidget {
  const LogInfoCard({super.key});

  @override
  State<LogInfoCard> createState() => _LogInfoCardState();
}

class _LogInfoCardState extends State<LogInfoCard> {
  int error = 0;
  int warning = 0;
  int info = 20;
  int debug = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: const EdgeInsets.all(10),
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFFFF91AE),
        // color: HexColor.fromHex("#a5dee5"),
        // color: Color(0xFF404040),
        boxShadow: [
          BoxShadow(color: Color(0xFFFF91AE), blurRadius: 40, spreadRadius: -10)
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "日志",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Sweet",
                  color: Colors.white,
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 40,
                  ))
            ],
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GridView.count(
                    mainAxisSpacing: 2.0, //
                    childAspectRatio: 2.8,
                    crossAxisCount: 2,
                    children: [
                      LogLevel(
                        color: Colors.red,
                        text: "错误",
                        number: error,
                      ),
                      LogLevel(
                        color: Colors.yellow,
                        text: "警告",
                        number: warning,
                      ),
                      LogLevel(color: Colors.green, text: "信息", number: info),
                      LogLevel(color: Colors.blue, text: "调试", number: debug),
                    ],
                  )))
        ],
      ),
    );
  }
}

class LogLevel extends StatelessWidget {
  final Color color;
  final String text;
  final int number;

  const LogLevel(
      {super.key,
      required this.color,
      required this.text,
      required this.number});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        width: 100,
        child: Stack(children: [
          Positioned(
            top: 5,
            child: Container(
              height: 30,
              width: 8,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(color: color, blurRadius: 10, spreadRadius: -2)
                  ]),
            ),
          ),
          Positioned(
              left: 15,
              child: Text(
                number.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
          Positioned(
              top: 30,
              left: 0,
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ))
        ]));
  }
}

class DetailedCoreInformation extends StatefulWidget {
  final String address;

  const DetailedCoreInformation({super.key, required this.address});

  @override
  State<DetailedCoreInformation> createState() =>
      _DetailedCoreInformationState();
}

class _DetailedCoreInformationState extends State<DetailedCoreInformation> {
  Map computerInfoData = {};

  @override
  void initState() {
    super.initState();
    getHttpRequest(widget.address);
  }

  Future getHttpRequest(String address) async {
    final response1 = await http.get(Uri.parse('$address/get_system'));

    if (response1.statusCode == 200) {
      computerInfoData = jsonDecode(utf8.decode(response1.bodyBytes));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String system = computerInfoData["system_name"] ?? "未获取到系统信息";
    String gpu = computerInfoData["gpu_name"] ?? "未获取到显卡信息";
    String cpu = computerInfoData["cpu_model"] ?? "未获取到CPU信息";
    String ram = computerInfoData["system_memory"] != null
        ? "${computerInfoData["system_memory"]}GB"
        : "未获取到内存信息";
    String storage = "1TB SSD";
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "核心信息",
          style: TextStyle(
            fontSize: 25,
            fontFamily: "Sweet",
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 5,
              height: 25,
              color: const Color(0xFFFD6B6F),
            ),
            const Text(
              "操作系统",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                system,
                // overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 5,
              height: 25,
              color: const Color(0xFFFD6B6F),
            ),
            const Text(
              "显卡",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Text(
                gpu,
                // overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 5,
              height: 25,
              color: const Color(0xFFFD6B6F),
            ),
            const Text(
              "处理器",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                cpu,
                // overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 5,
              height: 25,
              color: const Color(0xFFFD6B6F),
            ),
            const Text(
              "运行内存",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Container(
              // width: 100,
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                ram,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 5,
              height: 25,
              color: const Color(0xFFFD6B6F),
            ),
            const Text(
              "磁盘储存",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                storage,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ))
          ],
        )
      ]),
    );
  }
}
