import 'package:encrypt/encrypt.dart';
import 'dart:io';

void main() async {
  File file = File("test/1.json");
  http: //p.qlogo.cn/gh/910671041/910671041/0
  // String plainText = await file.readAsString();
  String plainText = "123456";

  // 生成密钥和IV（初始化向量）
  final key = Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 必须是32个字符
  final iv = IV.fromLength(16); // IV长度为16字节

  // 使用AES CBC模式进行加密
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  // 打印加密后的内容
  print('Encrypted: ${encrypted.base64}');

  // 使用相同的密钥和IV解密
  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  // 打印解密后的内容
  print('Decrypted: $decrypted');
}
