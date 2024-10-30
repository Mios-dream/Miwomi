import 'dart:async';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class MusicManager with ChangeNotifier {
  List<MusicData?> _musicList = [];

  List<MusicData?> get musicList => _musicList;

  Future<void> searchMusic(String keyword) async {
    _musicList = await KuGouMusic().search(keyword);
    notifyListeners();
  }
}

class KuGouMusic {
  static const String _musicApi =
      "http://mobilecdn.kugou.com/api/v3/search/song?format=json&page=1&pagesize=20&showtype=1&keyword=";

  Future<List<MusicData?>> search(String keyword) async {
    String url = _musicApi + keyword;
    try {
      Response response = await get(Uri.parse(url));

      Map json = jsonDecode(response.body);
      var date = List.generate(json['data']['info'].length, (index) {
        return MusicData.fromJson(json['data']['info'][index]);
      });
      return date;
    } catch (e) {
      return [];
    }
  }
}

class MusicData {
  final String name;
  final String singer;
  final String url;
  final String cover;
  final String hash;
  final String extName;

  // final String album;
  // final String albumId;

  MusicData({
    required this.extName,
    required this.name,
    required this.singer,
    required this.url,
    required this.cover,
    required this.hash,
  });

  factory MusicData.fromJson(Map<String, dynamic> json) {
    return MusicData(
      name: json['songname'] ?? '',
      singer: json['singername'] ?? '',
      url: json['url'] ?? '',
      cover: (json['trans_param']['union_cover'] ??
              'https://imge.kugou.com/stdmusic/size/20240129/20240129155802980299.jpg')
          .replaceAll("{size}", "400"),
      hash: json['hash'] ?? '',
      extName: json['extname'] ?? '',
    );
  }

  static MusicData empty = MusicData(
    name: "",
    url: "",
    cover: "",
    hash: "",
    singer: '',
    extName: '',
  );
}
