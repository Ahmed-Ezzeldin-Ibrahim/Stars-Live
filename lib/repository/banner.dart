import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/contant.dart';

Future<void> getBanners() async {
  // http://starslive.club/public/api/banners/get;
  String url = '${baseLinkApi}/api/banners/get';

  var response = await http.post(
    Uri.parse(url),
    headers: {"Accept": "application/json"},
  );

  print('rrrrrrrrrrr  : ${response.statusCode}');

  try {
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body);
    } else {
      print("response.statusCode :${response.statusCode}");
    }
  } catch (e) {
    print('Errrorr : ${e}');
  }
}
