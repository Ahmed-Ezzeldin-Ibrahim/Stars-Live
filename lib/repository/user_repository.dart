import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'network_profile.dart';
import 'profile_response.dart';

import '../constant/contant.dart';
import '../helper/echo.dart';
import '../main_provider_model.dart';
import '../model/User.dart';

ValueNotifier<User> currentUser = ValueNotifier(User());

Future<User> logIn(BuildContext context, {User user}) async {
  final String url = '${baseLinkApi}login';
  final prefs = GetStorage();
  prefs.write('loginType', 'false');
  // Fluttertoast.showToast(msg: 'log in url:- $url');
  print('log in email:- ${user.email}');
  print('log in password:- ${user.password}');
  var response = await http.post(Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(<String, dynamic>{
        "login": user.email,
        "password": user.password,
      }));
  print('log in status code ${response.statusCode}');
  try {
    var decoded = jsonDecode(response.body);
    print(response.body);
    // Fluttertoast.showToast(msg:'log in response ${response.body}');
    if (response.statusCode == 200) {
      List data = decoded['data'];
      User cUser = User.fromJson(data[0]);
      print(cUser);
      currentUser.value = cUser;
      bool saveUserData = await setCurrentUserData(context, user: cUser);
      if (!saveUserData) {
        Fluttertoast.showToast(msg: 'Faild to save user data');
        return Future.error('storeUserData');
      }
      await getCurrentUser();
      return currentUser.value;
    } else {
      Fluttertoast.showToast(msg: decoded['msg']);
    }
  } catch (e) {
    print('log in Exception:- ${e.toString()}');
  }
  return null;
}

Future<User> userRegistration(BuildContext context, {User user}) async {
  final String url = '${baseLinkApi}register';
  final prefs = GetStorage();
  prefs.write('loginType', 'false');
  print('user registration url:- $url');
  print('user registration email:- ${user.email}');
  print('user registration password:- ${user.password}');
  print('user registration name:- ${user.name}');
  print('user registration name:- ${user.phone}');
  print('user registration name:- ${user.country}');
  print('user registration name:- ${user.longitude}');
  print('user registration name:- ${user.latitude}');

  if (user.gender == "ذكر") {
    user.gender = 'male';
  } else if (user.gender == "انثي") {
    user.gender = 'female';
  } else {
    user.gender = user.gender;
  }
  print('user registration name:- ${user.gender}');
  var response = await http.post(Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(<String, dynamic>{
        "name": user.name,
        "email": user.email,
        "phone": user.phone,
        "gender": user.gender,
        "password": user.password,
        "country": user.country,
        "latitude": user.latitude,
        "longitude": user.longitude,
        "device_token": '${Random().nextInt(999999)}',
      }));
  print('user registration  response ${response.body}');
  try {
    print('user registration  response ${response.body}');
    print('user registration  status code ${response.statusCode}');
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('data 1');
      List data = decoded['data'];
      print('data 2');
      print('data ${data}');
      User cUser = data.map((e) => User.fromJson(e)).first;
      currentUser.value = cUser;

      bool saveUserData = await setCurrentUserData(context, user: cUser);
      if (!saveUserData) {
        Fluttertoast.showToast(msg: 'Faild to save user data');
        return Future.error('storeUserData');
      }
      await getCurrentUser();
      return currentUser.value;
    } else {
      // Fluttertoast.showToast(msg: 'فشل فى انشاء الحساب');
      Fluttertoast.showToast(msg: decoded['msg']);
      Fluttertoast.showToast(msg: '${decoded['errors']}');
    }
  } catch (e) {
    print('user registration Exception:- $e');
  }
  return null;
}

Future<User> googleFaceBookRegistration(BuildContext context, {User user}) async {
  Echo('googleFaceBookRegistration');
  final String url = '${baseLinkApi}social/login';
  var decoded;
  print('user registration url:- $url');
  print('user registration email:- ${user.email}');
  print('user registration name:- ${user.name}');
  print('user registration phone:- ${user.phone}');
  print('user registration id:- ${user.google_id}');

  try {
    Map<String, dynamic> queryParameters = Map();
    queryParameters['name'] = user.name;
    queryParameters['email'] = user.email;
    queryParameters['facebook_id'] = user.google_id;
    queryParameters['device_token'] = user.google_id;
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    Response response = await dio.post('$url', queryParameters: queryParameters);
    ProfileResponse profileModel = new ProfileResponse.fromJson(response.data);

    if (response.statusCode == 200) {
      final prefs = GetStorage();
      prefs.write('name', user.name);
      prefs.write('email', user.email);
      prefs.write('google_id', user.google_id);
      prefs.write('loginType', 'true');

      print('data ${response.data}');

      currentUser.value.id = profileModel.data.first.id;
      currentUser.value.type = profileModel.data.first.type;
      currentUser.value.name = profileModel.data.first.name;
      currentUser.value.email = profileModel.data.first.email;
      currentUser.value.phone = profileModel.data.first.phone;
      currentUser.value.image = profileModel.data.first.image;
      currentUser.value.diamonds = profileModel.data.first.diamonds;
      currentUser.value.followed = profileModel.data.first.followed;
      currentUser.value.salary = profileModel.data.first.salary;
      currentUser.value.diamonds = profileModel.data.first.diamonds;
      currentUser.value.balanceInCoins = profileModel.data.first.balanceInCoins;
      currentUser.value.totalReceivedGifts = profileModel.data.first.totalReceivedGifts;
      currentUser.value.apiToken = profileModel.data.first.apiToken;
      currentUser.value.userHostLevel = profileModel.data.first.levelHost;
      currentUser.value.userLevel = profileModel.data.first.levelUser;
      Provider.of<MainProviderModel>(context, listen: false).profileData = currentUser.value;

      bool saveUserData = await setCurrentUserData(context, user: currentUser.value);
      if (!saveUserData) {
        Fluttertoast.showToast(msg: 'Faild to save user data');
        return Future.error('storeUserData');
      }
      await getCurrentUser();
      return currentUser.value;
    } else {
      // Fluttertoast.showToast(msg: 'فشل فى انشاء الحساب');
      Fluttertoast.showToast(msg: decoded['mesg']);
    }
  } catch (e) {
    print('user registration Exception:- ${e["message"]}');
  }
  return null;
}

userUpdate(BuildContext context, {User user}) async {
  final String url = '${baseLinkApi}profile/update';
  print('user update url:- $url');
  print('user update name:- ${user.name}');
  print('user update phone:- ${user.phone}');
  print('user update email:- ${user.email}');
  print('user update file:- ${currentUser.value.apiToken}');
  try {
    Response response;
    FormData formData = FormData.fromMap({
      "name": user.name,
      "email": user.email,
      "phone": user.phone,
      "image": user.file == null
          ? null
          : await MultipartFile.fromFile(
              user.file.path.replaceAll('file://', ''),
            ),
    });
    response = await Dio().post(url,
        data: formData,
        options: Options(headers: {
          "Accept": 'application/json',
          "Bearer": "${currentUser.value.apiToken}",
          "Authorization": "Bearer ${currentUser.value.apiToken}",
        }));
    print('user update response:- ${response.data}');
    print('user update statuscode:- ${response.statusCode}');
    List decoded = response.data['data'];
    if (response.statusCode == 200) {
      print('updated');
      User cUser = decoded.map((e) => User.fromJson(e)).first;
      currentUser.value.name = cUser.name;
      currentUser.value.email = cUser.email;
      currentUser.value.phone = cUser.phone;
      currentUser.value.image = cUser.image;
      bool saveUserData = await setCurrentUserData(context, user: cUser);
      if (!saveUserData) {
        Fluttertoast.showToast(msg: 'Faild to save user data');
        return;
      }
      getCurrentUser();
      return currentUser.value;
    } else {
      Fluttertoast.showToast(msg: response.data['msg']);
      return null;
    }
  } catch (e) {
    print('user update Exception:- $e');
  }
  return null;
}

Future<bool> setCurrentUserData(BuildContext context, {User user, String token}) async {
  Provider.of<MainProviderModel>(context, listen: false).profileData = currentUser.value;
  int i = 0;
  try {
    if (user != null) {
      final prefs = GetStorage();
      await prefs.write('current_user_name', currentUser.value.name);
      i++;
      Echo('current_user_name , ${currentUser.value.name}');
      await prefs.write('current_user_apiToken', currentUser.value.apiToken);
      i++;
      Echo('current_user_apiToken , ${currentUser.value.apiToken}');
      await prefs.write('current_user_deviceToken', currentUser.value.deviceToken);
      i++;
      Echo('current_user_deviceToken , ${currentUser.value.deviceToken}');
      await prefs.write('current_user_email', currentUser.value.email);
      i++;
      Echo('current_user_email , ${currentUser.value.email}');
      await prefs.write('current_user_coins', currentUser.value.balanceInCoins);
      i++;
      Echo('current_user_balanceInCoins , ${currentUser.value.balanceInCoins}');
      await prefs.write('current_user_id', currentUser.value.id);
      i++;
      Echo('current_user_id , ${currentUser.value.id}');
      await prefs.write('current_user_phone', currentUser.value.phone);
      i++;
      Echo('current_user_phone , ${currentUser.value.phone}');
      await prefs.write('current_user_gender', currentUser.value.gender);
      i++;
      Echo('current_user_gender , ${currentUser.value.gender}');
      await prefs.write('current_user_image', currentUser.value.image);
      i++;
      Echo('current_user_image , ${currentUser.value.image}');
      await prefs.write('current_user_country', currentUser.value.country);
      i++;
      Echo('current_user_country , ${currentUser.value.country}');
      await prefs.write('current_user_latitude', currentUser.value.latitude);
      i++;
      Echo('current_user_latitude , ${currentUser.value.latitude}');
      await prefs.write('current_user_longitude', currentUser.value.longitude);
      i++;
      Echo('current_user_longitude , ${currentUser.value.longitude}');
      return true;
    }
  } catch (e) {
    print('SharedPreferance Excetpion $i =' + e.toString());
    return false;
  }
}

Future<void> setLiveUser(String isLive) async {
  final String url = '${baseLinkApi}user/set_live_status';

  var response = await http.post(Uri.parse(url), body: {
        "live": isLive,
      }, headers: {
        "Accept": "application/json",
        "Bearer": "${currentUser.value.apiToken}",
        "Authorization": "Bearer ${currentUser.value.apiToken}"
      }),
      decodedBody = jsonDecode(response.body);
  /*if (isLive == "1") {
    liveList.add(liveUser);
  } else {
    liveList.remove(liveUser);
  }*/
}

// Future<void> getToken(String userID) async {
//   final String url = '${baseLinkApi}agora/get_token';
//   var response = await http.post(Uri.parse(url), body: <String, dynamic>{
//         "user_id": userID,
//       }, headers: {
//         "Accept": "application/json",
//         "Bearer": "${currentUser.value.apiToken}",
//         "Authorization": "Bearer ${currentUser.value.apiToken}"
//       }),
//       decodedBody = jsonDecode(response.body)['data']['live_token'];
//   agoraToken = decodedBody;
//   print(decodedBody);
// }

Future<String> createToken(String userName) async {
  final String url = '${baseLinkApi}agora/create_token';
  var response = await http.post(Uri.parse(url), body: <String, dynamic>{
        "channelName": userName,
      }, headers: {
        "Accept": "application/json",
        "Bearer": "${currentUser.value.apiToken}",
        "Authorization": "Bearer ${currentUser.value.apiToken}"
      }),
      decodedBody = jsonDecode(response.body)['data']['live_token'];
  agoraToken = decodedBody;
  Echo('create token $decodedBody');
  return decodedBody;
}

Future<void> deleteToken() async {
  final String url = '${baseLinkApi}agora/delete_token';
  var response = await http.post(Uri.parse(url), headers: {"Accept": "application/json", "Bearer": "${currentUser.value.apiToken}", "Authorization": "Bearer ${currentUser.value.apiToken}"});
  print(response.body.toString());
}

Future<User> getUserById(BuildContext context, {String userId}) async {
  Echo('$userId');
  final String url = '${baseLinkApi}user/get_by_id';
  var response = await http.post(Uri.parse(url), body: <String, dynamic>{
    'user_id': userId,
  }, headers: {
    "Accept": 'application/json',
    "Bearer": "${currentUser.value.apiToken}",
    "Authorization": "Bearer ${currentUser.value.apiToken}",
  });
  var decoded = jsonDecode(response.body)['data'];
  User user = decoded.map((e) => User.fromJson(e)).first;
  return user;
}

Future<String> getUserByIdDiamonds(BuildContext context, {String userId}) async {
  Echo('getUserByIdDiamonds');
  ProfileResponse response = await networkGetProfile(context);
  if (response.data != null) if (response.data.first != null) if (response.data.first.totalReceivedGifts != null) return '${response.data.first.totalReceivedGifts}';
  return '0';
  // Echo('$userId');
  // final String url = '${baseLinkApi}user/get_by_id';
  // var response = await http.post(Uri.parse(url), body: <String, dynamic>{
  //   'user_id': userId,
  // }, headers: {
  //   "Accept": 'application/json',
  //   "Bearer": "${currentUser.value.apiToken}",
  //   "Authorization": "Bearer ${currentUser.value.apiToken}",
  // });
  // var decoded = jsonDecode(response.body)['data'];
  // Echo('${jsonDecode(response.body)['data']}');

  // User user = decoded.map((e) => User.fromJson(e)).first;
  // Echo('getUserByIdDiamonds');
  // Echo(user.toJson().toString());
  // return '${user.totalReceivedGifts}';
}

Future<User> getCurrentUser() async {
  final prefs = GetStorage();
  //prefs.clear();
  if (currentUser.value.auth == null && prefs.read('current_user_name') != null && prefs.read('current_user_email') != null && prefs.read('current_user_id') != null) {
    currentUser.value.name = await prefs.read('current_user_name');
    currentUser.value.apiToken = await prefs.read('current_user_apiToken');
    currentUser.value.email = await prefs.read('current_user_email');
    currentUser.value.id = await prefs.read('current_user_id');
    currentUser.value.phone = await prefs.read('current_user_phone');
    currentUser.value.gender = await prefs.read('current_user_gender');
    currentUser.value.country = await prefs.read('current_user_country');
    // currentUser.value.followers = await prefs.get('current_user_followers');
    // currentUser.value.followeds = await prefs.get('current_user_followeds');
    currentUser.value.longitude = await prefs.read('current_user_longitude');
    currentUser.value.latitude = await prefs.read('current_user_latitude');
    currentUser.value.auth = true;
  } else {
    currentUser.value.auth = false;
  }
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  print("User DATA *****");
  print(currentUser.value.apiToken);
  return currentUser.value;
}

Future<void> logout() async {
  final String url = '${baseLinkApi}logout';
  final prefs = GetStorage();
  prefs.write('loginType', 'false');
  var response = await http.post(
    Uri.parse(url),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      "Token": "${currentUser.value.apiToken}"
      // "Token": currentUser.value.apiToken
    },
  );
  if (currentUser != null) currentUser.value = new User();
  await prefs.remove('current_user_name');
  await prefs.remove('current_user_email');
  await prefs.remove('current_user_id');
  Echo('logout');
  Fluttertoast.showToast(msg: 'log out done successfully');
}
