import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/my_app_data.dart';
import '../widgets/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddRobotPage extends StatelessWidget {
  const AddRobotPage({Key? key}) : super(key: key);

  String _formatAddress(String address) {
    if (address.endsWith('/')) {
      // 去掉斜杠
      address = address.substring(0, address.length - 1);
    }

    return address;
  }

  Future<Map> getBasicInfo(address) async {
    Map data = {"user_id": "", "nickname": ""};
    try {
      final response = await http
          .get(Uri.parse("$address/bot_info"))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        return data;
      }
    } catch (_) {
      // notificationToast(text: e.toString(), level: 3);

      return {"user_id": "", "nickname": ""};
    }
  }

  @override
  Widget build(BuildContext context) {
    MyAppData myAppData = Provider.of<MyAppData>(context);
    final TextEditingController nameTextEditingController =
        TextEditingController();
    final TextEditingController addressTextEditingController =
        TextEditingController();
    final TextEditingController tokenTextEditingController =
        TextEditingController();
    Map newRobot = {};
    return Scaffold(
        appBar: addRobotBar(context),
        body: Container(
          color: const Color(0xFFFFC4D7),
          child: Stack(
            children: [
              Positioned(
                  top: 200,
                  left: 50,
                  right: 50,
                  child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Card(
                        elevation: 15,
                        shadowColor: const Color(0xFFFFC4D7),
                        surfaceTintColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                width: double.infinity,
                                child: TextFormField(
                                  controller: nameTextEditingController,
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      const InputDecoration(hintText: "name"),
                                )),
                            Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                width: double.infinity,
                                child: TextFormField(
                                  controller: addressTextEditingController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      hintText: "address"),
                                )),
                            Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                width: double.infinity,
                                child: TextFormField(
                                  controller: tokenTextEditingController,
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      const InputDecoration(hintText: "token"),
                                ))
                          ],
                        ),
                      ))),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 150),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100), //设置盒子的圆角
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage("assets/images/Elysia.jpg"),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(100), //设置盒子的圆角
                      ),
                    ),
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFF795B1),
                        blurRadius: 15,
                      )
                    ],
                  ),
                  margin: const EdgeInsets.only(top: 550),
                  child: IconButton(

                      // 事件
                      onPressed: () {
                        if (nameTextEditingController.text.isNotEmpty &&
                            addressTextEditingController.text.isNotEmpty &&
                            tokenTextEditingController.text.isNotEmpty) {
                          String address =
                              _formatAddress(addressTextEditingController.text);
                          getBasicInfo(address).then((Map data) {
                            newRobot = {
                              "name": nameTextEditingController.text,
                              "token": tokenTextEditingController.text,
                              "address": _formatAddress(address),
                              "user_id": data["user_id"],
                              "user_name": data["nickname"],
                            };
                            myAppData.addRobot(newRobot);
                            // notificationToast(
                            //     text: "添加成功( •̀ ω •́ )✧", level: 2);
                          });
                        } else {
                          notificationToast(
                              text: "欸？信息还没输入完Σ(っ °Д °;)っ", level: 1);
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 50,
                        color: Color(0xFFF795B1),
                      )),
                ),
              )
            ],
          ),
        ));
  }
}

AppBar addRobotBar(context) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    backgroundColor: const Color(0xFFFFC4D7),
    title: const Text("添加机器人",
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    centerTitle: true,
  );
}
