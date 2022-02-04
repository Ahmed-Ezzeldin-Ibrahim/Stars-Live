import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../constant/contant.dart';
import '../controller/profie_controller.dart';
import '../model/User.dart';
import 'user_repository.dart';

addToFollowings({int follow_id}) async{
  final String url = '${baseLinkApi}user/follow';
  try{
    Response response;
    FormData formData = FormData.fromMap({
      "follow_id": follow_id,
    });
    response = await Dio().post(url,
        data: formData,
        options: Options(headers: {
          "Accept": 'application/json',
          "Bearer": "${currentUser.value.apiToken}",
          "Authorization": "Bearer ${currentUser.value.apiToken}",
        }));
    print('addToFollowings response:- ${response.data}');
    print('addToFollowings statuscode:- ${response.statusCode}');
    List decoded = response.data['data'];
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: response.data['msg']);
    }else{
      Fluttertoast.showToast(msg: response.data['msg']);
    }
  }catch(e){
    print('addToFollowings Exception:- $e');
  }
}

removeFromFollowings({int follow_id}) async{
  final String url = '${baseLinkApi}user/un_follow';
  try{
    Response response;
    FormData formData = FormData.fromMap({
      "follow_id": follow_id,
    });
    response = await Dio().post(url,
        data: formData,
        options: Options(headers: {
          "Accept": 'application/json',
          "Bearer": "${currentUser.value.apiToken}",
          "Authorization": "Bearer ${currentUser.value.apiToken}",
        }));
    print('removeFromFollowings response:- ${response.data}');
    print('removeFromFollowings statuscode:- ${response.statusCode}');
    List decoded = response.data['data'];
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: response.data['msg']);
    }else{
      Fluttertoast.showToast(msg: response.data['msg']);
    }
  }catch(e){
    print('removeFromFollowings Exception:- $e');
  }
}