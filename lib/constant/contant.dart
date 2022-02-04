import 'package:flutter/cupertino.dart';

import '../localization/AppLocalizations.dart';

Color baseColor = Color(0xff8A47F8);
Color outLineColor = Color.fromRGBO(30, 144, 47, 1);
Color backColor = Color.fromRGBO(11, 109, 20, 1);
String baseLinkApi = 'http://starslive.club/public/api/';

String localized(BuildContext context, String text) {
  return AppLocalizations.of(context).translate(text);
}

enum MenuOptions { switchcamera, share }
const appId = 'a1f530f3b94547b795bac51ceaeadba4';

const chatId = '948951d038594aa49ffbae794a5ae2b1';
const rtmToken = "006a1f530f3b94547b795bac51ceaeadba4IABijDwTL4uj1NH6MffQNwKi0vXGXQUrsuzkxNN8Wn1Oz7fv3IMAAAAAEABoNgAAIziyYQEA6AOz9LBh";
String agoraToken;

class AppColors {
  Color primaryColor({double opacity = 1}) {
    return Color(0xFF9B2CF5).withOpacity(opacity);
  }

  Color primaryDarkColor({double opacity = 1}) {
    return Color(0xFF6D27E9).withOpacity(opacity);
  }

  Color primaryLightColor({double opacity = 1}) {
    return Color(0xFFE338F4).withOpacity(opacity);
  }

  Color accentColor({double opacity = 1}) {
    return Color(0xFF1E003E).withOpacity(opacity);
  }
}
