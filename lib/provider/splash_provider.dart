import 'package:flutter/cupertino.dart';
import '../model/splashModel.dart';

class SplashProvider extends ChangeNotifier{
  splash s ;

  getSplash() async {
    s  = await getSplash();
    notifyListeners();
  }
}

