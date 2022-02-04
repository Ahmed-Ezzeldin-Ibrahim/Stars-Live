import 'package:flutter/material.dart';

class AppColors {
  Color primaryColor({double opacity = 1}) {
    return Color(0xFFF5AF2C).withOpacity(opacity);
  }

  Color primaryDarkColor({double opacity = 1}) {
    return Color(0xFFB66700).withOpacity(opacity);
  }

  Color primaryLightColor({double opacity = 1}) {
    return Color(0xFFFCC766).withOpacity(opacity);
  }

  Color accentColor({double opacity = 1}) {
    return Color(0xFF1E003E).withOpacity(opacity);
  }
}

class AppStrings {
  static const String PLAY_STORE = '';
  static const String APP_STORE = '';
  static const double CURRENCY_USD_SAR = 0.27;
  static const String AGORA_ID = 'a1f530f3b94547b795bac51ceaeadba4';
}
