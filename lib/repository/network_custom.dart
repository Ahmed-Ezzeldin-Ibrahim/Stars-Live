import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main_provider_model.dart';

import '../helper/echo.dart';

Future<Response> networkCustom({
  @required BuildContext context,
  @required String apiUrl,
  @required Map<String, dynamic> queryParameters,
  @required bool methodPost,
}) async {
  MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
  try {
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${mainProviderModel.profileData.apiToken}";
    if (queryParameters != null)
      queryParameters.forEach((key, value) {
        Echo('queryParameters key=$key value=$value');
      });
    Echo('Bearer ${mainProviderModel.profileData.apiToken}');

    Response response;
    if (methodPost)
      response = await dio.post('$apiUrl', queryParameters: queryParameters);
    else
      response = await dio.get('$apiUrl', queryParameters: queryParameters);
    return response;
  } on DioError catch (e) {
    Echo('error $e');
    return Future.error('error $e');
  }
}
