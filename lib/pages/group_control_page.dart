import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../data/my_app_data.dart';
import 'package:http/http.dart' as http;

class GroupControlPage extends StatelessWidget {
  const GroupControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);
    String address = myAppData.robots[myAppData.selectedCardIndex]["address"];
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
        title: const Text("群管理",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: GroupControlBody(address: address),
    );
  }
}

class GroupControlBody extends StatefulWidget {
  final String address;

  const GroupControlBody({super.key, required this.address});

  @override
  State<GroupControlBody> createState() => _GroupControlBodyState();
}

class _GroupControlBodyState extends State<GroupControlBody> {
  List data = [];

  @override
  void initState() {
    super.initState();
    getHttpRequest(widget.address);
  }

  Future getHttpRequest(String address) async {
    final response = await http.get(Uri.parse('$address/group_list'));

    if (response.statusCode == 200) {
      data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);
    String address = myAppData.robots[myAppData.selectedCardIndex]["address"];

    return Container(
        color: const Color(0xFFF1F3F7),
        height: double.infinity,
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return GroupCard(
                groupName: data[index]["group_name"],
                groupID: data[index]["group_id"],
                image: NetworkImage(
                    "http://p.qlogo.cn/gh/${data[index]["group_id"]}/${data[index]["group_id"]}/0"),
                isSwitched: data[index]["is_enable"],
                address: address,
              );
            }));
  }
}

class GroupCard extends StatefulWidget {
  final String groupName;
  final int groupID;
  final ImageProvider image;
  final bool isSwitched;
  final String address;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.groupID,
    required this.image,
    required this.isSwitched,
    required this.address,
  });

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool isSwitched = false;
  late String address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSwitched = widget.isSwitched;
    address = widget.address;
  }

  Future<void> postHttpRequest(int groupId, bool value) async {
    var url = '$address/group_list';
    var data = {"group_id": groupId, "is_enable": value};

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      showToastWidget(Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 180,
          height: 60,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 100, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.white, blurRadius: 20, spreadRadius: 0)
            ],
            borderRadius: BorderRadius.circular(10), //设置盒子的圆角
          ),
          child: const Row(children: [
            Icon(Icons.check_circle_outline,
                size: 30, color: Color(0xFFF795B1)),
            SizedBox(
              width: 10,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Successful",
              ),
              Text(
                "设置成功( •̀ ω •́ )✧",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            ])
          ]),
        ),
      ));
    } else {
      showToastWidget(Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 180,
          height: 60,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 100, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.white, blurRadius: 20, spreadRadius: 0)
            ],
            borderRadius: BorderRadius.circular(10), //设置盒子的圆角
          ),
          child: const Row(children: [
            Icon(Icons.check_circle_outline,
                size: 30, color: Color(0xFFF795B1)),
            SizedBox(
              width: 10,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Error",
              ),
              Text(
                "设置失败",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            ])
          ]),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white70],
        ),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFF784A7),
              blurRadius: 30,
              spreadRadius: -20,
              offset: Offset(5, 10))
        ],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(fit: BoxFit.cover, image: widget.image)),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    widget.groupName,
                    overflow: TextOverflow.ellipsis, // 设置溢出时显示省略号
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "${widget.groupID}",
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                )
              ],
            ),
          ],
        ),
        Switch(
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFFFF7EA1),
          inactiveThumbColor: const Color(0xFFFF91AE),
          inactiveTrackColor: Colors.white,
          trackOutlineColor: WidgetStateProperty.resolveWith((Set states) {
            return Colors.transparent; // Use the default color.
          }),
          value: isSwitched,
          onChanged: (bool value) {
            setState(() {
              isSwitched = value;
              postHttpRequest(widget.groupID, value);
            });
          },
        ),
      ]),
    );
  }
}
