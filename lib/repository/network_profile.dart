import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../constant/contant.dart';
import '../helper/echo.dart';
import '../main_provider_model.dart';
import '../model/User.dart';
import 'profile_response.dart';
import 'user_repository.dart';

Future<ProfileResponse> networkGetProfile(BuildContext context) async {
  final prefs = GetStorage();

  String loginType = prefs.read('loginType');
  Echo('loginType $loginType');
  if (loginType == null || loginType == 'false' || loginType.isEmpty) {
    Echo('loginType login');
    try {
      Dio dio = Dio();
      dio.interceptors.add(LogInterceptor(responseBody: true));
      dio.options.headers['content-Type'] = 'application/json';

      Map<String, dynamic> queryParameters = Map();
      queryParameters['login'] = prefs.read('email') ?? '';
      queryParameters['password'] = prefs.read('password') ?? '';

      Response response = await dio.post('${baseLinkApi}login', queryParameters: queryParameters);
      ProfileResponse profileModel = new ProfileResponse.fromJson(response.data);

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
      await setCurrentUserData(context, user: currentUser.value);
      MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
      mainProviderModel.profileResponse = profileModel;
      Echo('${mainProviderModel.profileResponse.data.length}');

      return profileModel;
    } on DioError catch (e) {
      currentUser.value = new User();
      final prefs = GetStorage();
      await prefs.remove('current_user_name');
      await prefs.remove('current_user_email');
      await prefs.remove('current_user_id');
      Navigator.of(context).pushNamed('/Login');
      Echo('error $e');
      return Future.error('error $e');
    }
  } else {
    Echo('loginType social');
    try {
      String name = prefs.read('name');
      String email = prefs.read('email');
      String google_id = prefs.read('google_id');
      final String url = '${baseLinkApi}social/login';

      Map<String, dynamic> queryParameters = Map();
      queryParameters['name'] = name;
      queryParameters['email'] = email;
      queryParameters['facebook_id'] = google_id;
      queryParameters['device_token'] = google_id;
      Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      Response response = await dio.post('$url', queryParameters: queryParameters);
      ProfileResponse profileModel = new ProfileResponse.fromJson(response.data);

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
      currentUser.value.shift_transferred_usd = profileModel.data.first.shift_transferred_usd;
      currentUser.value.totalReceivedGifts = profileModel.data.first.totalReceivedGifts;
      currentUser.value.apiToken = profileModel.data.first.apiToken;
      currentUser.value.userHostLevel = profileModel.data.first.levelHost;
      currentUser.value.userLevel = profileModel.data.first.levelUser;
      await setCurrentUserData(context, user: currentUser.value);
      MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
      mainProviderModel.profileResponse = profileModel;
      Echo('${mainProviderModel.profileResponse.data.length}');

      return profileModel;
    } on DioError catch (e) {
      currentUser.value = new User();
      final prefs = GetStorage();
      await prefs.remove('current_user_name');
      await prefs.remove('current_user_email');
      await prefs.remove('current_user_id');
      Navigator.of(context).pushNamed('/Login');
      Echo('error $e');
      return Future.error('error $e');
    }
  }
}

Future<ProfileResponse> networkMyInfo(BuildContext context) async {
  final prefs = GetStorage();

  try {
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.options.headers['content-Type'] = 'application/json';

    Response response = await dio.get('${baseLinkApi}user/my-data');
    ProfileResponse profileModel = new ProfileResponse.fromJson(response.data);

    await setCurrentUserData(context, user: currentUser.value);
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
    mainProviderModel.profileResponse = profileModel;
    Echo('${mainProviderModel.profileResponse.data.length}');

    return profileModel;
  } on DioError catch (e) {
    currentUser.value = new User();
    final prefs = GetStorage();
    await prefs.remove('current_user_name');
    await prefs.remove('current_user_email');
    await prefs.remove('current_user_id');
    Navigator.of(context).pushNamed('/Login');
    Echo('error $e');
    return Future.error('error $e');
  }
}
