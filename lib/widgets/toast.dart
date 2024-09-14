import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

///level: 0 info 1 success 2 warning 3 error
ToastFuture notificationToast({required String text, required int level}) {
  List levelList = ["Info", "Warning", "Success", "Error"];
  List<IconData> myIcons = [
    Icons.info_outline,
    Icons.info_outline,
    Icons.check_circle_outline,
    Icons.error_outline
  ];

  return showToastWidget(
      duration: const Duration(seconds: 3),
      Align(
          alignment: Alignment.topRight,
          child: IntrinsicWidth(
            child: Container(
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 100, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.white, blurRadius: 20, spreadRadius: 0)
                ],
                borderRadius: BorderRadius.circular(10), //设置盒子的圆角
              ),
              child: Row(children: [
                Icon(myIcons[level], size: 30, color: const Color(0xFFF795B1)),
                const SizedBox(
                  width: 10,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    levelList[level],
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                ])
              ]),
            ),
          )));
}
