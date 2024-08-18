import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:robot_control/pages/state_page.dart';

class MyAppData extends ChangeNotifier {
  // 主页机器人选择卡片索引
  static int _selectedCardIndex = 1;

  int get selectedCardIndex => _selectedCardIndex;

  void selectCard(int index) {
    if (_selectedCardIndex != index) {
      _selectedCardIndex = index;
    }
    notifyListeners();
  }

  // 机器人主开关
  static bool _mainSwitch = true;

  bool get mainSwitch => _mainSwitch;

  void setMainSwitchState(bool value) {
    _mainSwitch = value;

    notifyListeners();
  }

  // 机器人主开关
  static bool _mainPluginSwitch = true;

  bool get mainPluginSwitch => _mainPluginSwitch;

  void setMainPluginSwitchState(bool value) {
    _mainPluginSwitch = value;

    notifyListeners();
  }
}
