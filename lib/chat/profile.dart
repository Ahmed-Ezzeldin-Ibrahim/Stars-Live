import 'package:flutter/foundation.dart';

import '../helper/echo.dart';

class ProfileModel with ChangeNotifier {
  String _name;
  String _email;
  String _phone;
  String _userId;
  String _userImage;
  String _tokenId;
  String _fcmToken;



  String get fcmToken => _fcmToken;

  set fcmToken(String value) {
    _fcmToken = value;
    notifyListeners();
  }

  String get tokenId => _tokenId;

  set tokenId(String value) {
    _tokenId = value;
    notifyListeners();
    Echo("update token $value");
  }

  String get userImage => _userImage;

  set userImage(String value) {
    _userImage = value;
    notifyListeners();
    Echo("update userImage$value");
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
    notifyListeners();
    Echo("update userId $value");
  }

  String get email => _email;

  set email(String value) {
    _email = value;
    notifyListeners();
    Echo("update email $value");
  }
  String get phone => _phone;

  set phone(String value) {
    _phone = value;
    notifyListeners();
    Echo("update phone $value");
  }


  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
    Echo("update name $value");
  }
}
