import 'package:flutter/cupertino.dart';
import '../model/bannerModel.dart';
import '../repository/banner_repository.dart';

class BannerProvider extends ChangeNotifier{
  homeBanner b ;

  getBanners() async {
    b  = await getHomeBanners();
    notifyListeners();
  }
}

