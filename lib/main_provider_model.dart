import 'package:flutter/foundation.dart';
import 'model/User.dart';
import 'repository/profile_response.dart';

class MainProviderModel with ChangeNotifier {
  User _profileData;
  ProfileResponse _profileResponse;


  ProfileResponse get profileResponse => _profileResponse;

  set profileResponse(ProfileResponse value) {
    _profileResponse = value;
    notifyListeners();
  }
  User get profileData => _profileData;

  set profileData(User value) {
    _profileData = value;
    notifyListeners();
  }
}
