import 'package:flutter/material.dart';

class AddRobotPage extends StatelessWidget {
  const AddRobotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                  decoration:
                                      const InputDecoration(hintText: "name"),
                                  validator: (name) {
                                    if (name == null || name.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return '输入';
                                  },
                                )),
                            Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                width: double.infinity,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: "address"),
                                  validator: (name) {
                                    if (name == null || name.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return '输入';
                                  },
                                )),
                            Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                width: double.infinity,
                                child: TextFormField(
                                  decoration:
                                      const InputDecoration(hintText: "token"),
                                  validator: (name) {
                                    if (name == null || name.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return '输入';
                                  },
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
                      onPressed: () {},
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
