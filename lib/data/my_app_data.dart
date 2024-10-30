import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MyAppData extends ChangeNotifier {
  // 是否数据加载完成
  static bool isFinished = false;

  // 文件保存的数据对象
  final SharedPreferencesAsync asyncData = SharedPreferencesAsync();

  // 机器人列表
  late List _robots;

  List get robots => _robots;

  void addRobot(Map robot) async {
    _robots.add(robot);
    await asyncData.setString("robots", jsonEncode(_robots));
    notifyListeners();
  }

  void updateRobot(int index, Map robot) async {
    _robots[index] = robot;
    await asyncData.setString("robots", jsonEncode(_robots));
    notifyListeners();
  }

  void removeRobot(int index) async {
    _robots.removeAt(index);
    await asyncData.setString("robots", jsonEncode(_robots));
    notifyListeners();
  }

  // 主页机器人选择卡片索引
  late int _selectedCardIndex;

  int get selectedCardIndex => _selectedCardIndex;

  void selectCard(int index) async {
    if (_selectedCardIndex != index) {
      _selectedCardIndex = index;
      _address = _robots[index]["address"];
      _userId = _robots[index]["user_id"].toString();
      _userName = _robots[index]["user_name"];
      await asyncData.setInt("selectedCardIndex", index);
    }
    notifyListeners();
  }

  // 机器人地址
  late String _address;

  String get address => _address;

  bool _isAvailable = false;

  bool get isAvailable => _isAvailable;

  Future<bool> checkAvailable() async {
    if (_address == "") {
      _address =
          _robots.isNotEmpty ? _robots[_selectedCardIndex]["address"] : "";
    }
    try {
      final response = await http.get(Uri.parse("$_address/bot_info"));

      if (response.statusCode == 200) {
        _isAvailable = true;
        if (userId == "") {
          _userId =
              jsonDecode(utf8.decode(response.bodyBytes))["user_id"].toString();
          _userName = jsonDecode(utf8.decode(response.bodyBytes))["nickname"]
              .toString();
          updateRobot(_selectedCardIndex, {
            "name": _robots[_selectedCardIndex]["name"],
            "address": _robots[_selectedCardIndex]["address"],
            "token": _robots[_selectedCardIndex]["token"],
            "user_id": _userId,
            "user_name": _userName
          });
        }
      } else {
        _isAvailable = false;
      }
    } catch (_) {}

    notifyListeners();
    return _isAvailable;
  }

  String _userId = "";

  String get userId => _userId;

  String _userName = "";

  String get userName => _userName;

  Future<void> getBasicInfo() async {
    if (_address == "") {
      _address =
          _robots.isNotEmpty ? _robots[_selectedCardIndex]["address"] : "";
    }
    final response = await http.get(Uri.parse("$address/bot_info"));

    if (response.statusCode == 200) {
      if (userId == "") {
        _userId =
            jsonDecode(utf8.decode(response.bodyBytes))["user_id"].toString();
        _userName =
            jsonDecode(utf8.decode(response.bodyBytes))["nickname"].toString();
        updateRobot(_selectedCardIndex, {
          "name": _robots[_selectedCardIndex]["name"],
          "address": _robots[_selectedCardIndex]["address"],
          "token": _robots[_selectedCardIndex]["token"],
          "user_id": _userId,
          "user_name": _userName
        });
      }
    }
  }

  late bool _isWeatherEnable = false;

  bool get isWeatherEnable => _isWeatherEnable;

  void setWeatherEnable(bool enable) async {
    _isWeatherEnable = enable;
    await asyncData.setBool("isWeatherEnable", enable);
    notifyListeners();
  }

  Map _weatherNowDay = {"code": 0, "msg": "正坐在获取天气"};
  Map _weather3Day = {"code": 0, "msg": "正坐在获取天气"};

  Map get weatherNowDay {
    if (_weatherNowDay["code"] == 0) {
      _getWeather();
    }
    return _weatherNowDay;
  }

  Map get weather3Day {
    if (_weather3Day["code"] == 0) {
      _getWeather();
    }
    return _weather3Day;
  }

  void updateWeather() {
    _getWeather();
  }

  Future<void> _getWeather() async {
    bool serviceEnabled;
    LocationPermission permission;
    String appKey = "88dd791332094bdea87420a0da67483a";

    if (_isWeatherEnable == false) {
      // notifyListeners();
      return;
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _weatherNowDay = {"code": 1, "msg": "定位服务未开启"};
      _weather3Day = {"code": 1, "msg": "定位服务未开启"};
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _weatherNowDay = {"code": 1, "msg": "定位权限未开启"};
        _weather3Day = {"code": 1, "msg": "定位权限未开启"};
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _weatherNowDay = {"code": 1, "msg": "定位权限被永久拒绝"};
      _weather3Day = {"code": 1, "msg": "定位权限被永久拒绝"};
      notifyListeners();
      return;
    }
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    String currentLocation =
        "${position.longitude.toStringAsFixed(2)},${position.latitude.toStringAsFixed(2)}";
    try {
      final response1 = await http.get(Uri.parse(
          "https://devapi.qweather.com/v7/weather/now?location=$currentLocation&key=$appKey"));
      final response2 = await http.get(Uri.parse(
          "https://devapi.qweather.com/v7/weather/3d?location=$currentLocation&key=$appKey"));

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        _weatherNowDay = jsonDecode(utf8.decode(response1.bodyBytes));
        _weather3Day = jsonDecode(utf8.decode(response2.bodyBytes));
      } else {
        _weatherNowDay = {"code": 1, "msg": "获取天气失败"};
        _weather3Day = {"code": 1, "msg": "获取天气失败"};
      }
    } catch (_) {
      _weatherNowDay = {"code": 1, "msg": "获取天气失败"};
      _weather3Day = {"code": 1, "msg": "获取天气失败"};
    }
    notifyListeners();
  }

  // 机器人主开关
  late bool _mainSwitch;

  bool get mainSwitch => _mainSwitch;

  void setMainSwitchState(bool value) async {
    _mainSwitch = value;
    await asyncData.setBool("mainSwitch", value);
    notifyListeners();
  }

  // 机器人插件主开关
  late bool _mainPluginSwitch;

  bool get mainPluginSwitch => _mainPluginSwitch;

  void setMainPluginSwitchState(bool value) async {
    _mainPluginSwitch = value;
    await asyncData.setBool("mainPluginSwitch", value);
    notifyListeners();
  }

  late bool _mainGroupSwitch;

  bool get mainGroupSwitch => _mainGroupSwitch;

  void setMainGroupSwitchState(bool value) async {
    _mainGroupSwitch = value;
    await asyncData.setBool("mainGroupSwitch", value);
    notifyListeners();
  }

  Map pluginsData = {};

  Future<void> getPluginsData() async {
    final response = await http.get(Uri.parse("$address/plugin_list"));

    if (response.statusCode == 200) {
      pluginsData = jsonDecode(utf8.decode(response.bodyBytes));
      notifyListeners();
    }
  }

  Future<bool> updatePlugin(Map newPluginSetting) async {
    try {
      final response = await http.post(Uri.parse("$address/plugin_list"),
          body: jsonEncode(newPluginSetting));

      if (response.statusCode == 200) {
        await getPluginsData();
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  void initData() async {
    _robots = jsonDecode(await asyncData.getString("robots") ?? "[]");
    _selectedCardIndex = await asyncData.getInt("selectedCardIndex") ?? 0;
    _mainSwitch = await asyncData.getBool("mainSwitch") ?? true;
    _mainPluginSwitch = await asyncData.getBool("mainPluginSwitch") ?? true;
    _mainGroupSwitch = await asyncData.getBool("mainGroupSwitch") ?? true;
    _address = _robots.isNotEmpty ? _robots[_selectedCardIndex]["address"] : "";
    _userId = _robots.isNotEmpty ? _robots[_selectedCardIndex]["user_id"] : "";
    _userName =
        _robots.isNotEmpty ? _robots[_selectedCardIndex]["user_name"] : "";
    _isWeatherEnable = await asyncData.getBool("isWeatherEnable") ?? false;
    await checkAvailable();
    notifyListeners();
  }
}
