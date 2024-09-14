import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/my_app_data.dart';

class RequestApi {
  /*
   * API消息构建基类
   */

  final String echo = "";
  final Map params;
  final String action;

  RequestApi(this.action, this.params);
}

class ApiAdapter {
  /*
   * API消息发送
   */

  static Future<Map<String, dynamic>> send(
      MyAppData data, RequestApi requestApi) async {
    final robotData = data.robots[data.selectedCardIndex];
    final response = await http.post(
        Uri(
            scheme: 'http',
            host: robotData["address"],
            port: robotData["port"],
            path: '/${requestApi.action}',
            queryParameters: {
              'token': robotData["token"],
            }),
        body: jsonEncode(requestApi.params));

    if (response.statusCode == 200) {
      // 如果请求成功，则解析返回的数据
      return jsonDecode(response.body);
    } else {
      // 如果请求失败，则返回失败状态码
      return {"code": response.statusCode, "message": response.body};
    }
  }
}
