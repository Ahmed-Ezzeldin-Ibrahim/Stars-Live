import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/bannerModel.dart';
import 'user_repository.dart';

Future<homeBanner> getHomeBanners() async {
  var url = "http://starslive.club/public/api/banners/get?type=banner&place=trend";
  var response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json', "Authorization": "Bearer ${currentUser.value.apiToken}"});
  try {
    if (response.statusCode == 200) {
      Map<String, dynamic> m = jsonDecode(response.body);
      homeBanner b = homeBanner.fromJson(m);
      return b;
    } else {
      print("response.statusCode :${response.statusCode}");
      print("response.statusCode :${response.body.toString()}");
    }
  } catch (e) {
    print('Errrorr : ${e}');
  }
}
