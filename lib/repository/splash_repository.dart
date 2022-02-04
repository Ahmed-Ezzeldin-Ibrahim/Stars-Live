import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/splashModel.dart';

Future<splash> getSplash() async {
  var url = "http://starslive.club/public/api/banners/get?type=splash";
  var response = await http.get(Uri.parse(url), headers: {
    'Accept': 'application/json',
    //"Authorization": "Bearer ${currentUser.value.apiToken}"
    "Authorization": "Bearer 530|y1cKzJIJv6NseOMDBmrxlDPWQKGcHZyylkmA7gwL"
  });
  try {
    if (response.statusCode == 200) {
      Map<String, dynamic> m = jsonDecode(response.body);
      splash s = splash.fromJson(m);
      return s;
    } else {
      print("response.statusCode :${response.statusCode}");
      print("response.statusCode :${response.body.toString()}");
    }
  } catch (e) {
    print('Errrorr : ${e}');
  }
}
