import 'dart:convert';

// 通过简单的json序列化和反序列化实现深拷贝
Map<String, dynamic> deepCopy(Map original) {
  final encoded = jsonEncode(original);
  final decoded = jsonDecode(encoded);
  return Map<String, dynamic>.from(decoded);
}
