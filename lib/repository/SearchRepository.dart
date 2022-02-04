import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/contant.dart';
import '../model/User.dart';
import 'user_repository.dart';

Future<User> getUserById(context, {String userId}) async {
  final String url = '${baseLinkApi}user/get_by_id';
  print('get user by id url $url');
  var response = await http.post(Uri.parse(url), body: <String, dynamic>{
    'user_id': userId,
  }, headers: {
    "Accept": 'application/json',
    "Bearer": "${currentUser.value.apiToken}",
    "Authorization": "Bearer ${currentUser.value.apiToken}",
  });
  var decoded = jsonDecode(response.body)['data'];
  print("Bearer ${currentUser.value.apiToken}");
  print("This is Response by ID ******");
  print(response.body);
  User user = decoded.map((e) => User.fromJson(e)).first;
  print('you ar in get uder by id ${user.image}');
  print('you ar in get uder by id ${user.name}');
  print('you ar in get uder by id ${user.phone}');
  print('you ar in get uder by id ${user.email}');
  return user;
}
