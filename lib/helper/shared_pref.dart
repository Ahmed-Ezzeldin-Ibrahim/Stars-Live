import 'package:get_storage/get_storage.dart';

class YemenyPrefs {
  final box = GetStorage();

  /// **********    UserLang     ****************/
  setLanguage(String language) {
    box.write('language', language);
  }

  String getLanguage() {
    return box.read('language') == null ? 'ar' : box.read('language');
  }
  
  void logout() {
    setLanguage(null);
//    Navigator.of(context).pushNamedAndRemoveUntil(SplashController.id, (Route<dynamic> route) => false);
  }
}
