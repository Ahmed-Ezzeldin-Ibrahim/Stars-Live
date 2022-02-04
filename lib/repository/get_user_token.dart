import 'package:dio/dio.dart';
import 'user_repository.dart';

import '../constant/contant.dart';
import 'get_token_response.dart';

Future<GetTokenResponse> networkGetUserToken(String userId) async {
  try {
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${currentUser.value.apiToken}";

    Map<String, dynamic> queryParameters = Map();
    queryParameters['user_id'] = userId;

    Response response = await dio.post(
      '${baseLinkApi}agora/get_token',
      queryParameters: queryParameters,
    );
    GetTokenResponse getTokenResponse = new GetTokenResponse.fromJson(response.data);
    return getTokenResponse;
  } on DioError catch (e) {
    return Future.error('error $e');
  }
}
