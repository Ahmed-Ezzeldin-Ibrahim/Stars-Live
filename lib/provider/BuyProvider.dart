

import 'package:flutter/cupertino.dart';
import '../model/BuyModel.dart';
import '../model/User.dart';
import '../repository/Buy_repository.dart';
import '../repository/SearchRepository.dart';

class BuyProvider extends ChangeNotifier {
  BuyInfo user;

  getBuytoUser({String id , String Usd}) async {
    print(id);
    print(Usd);
    user = await getStatusofBuy(receiver_id: id ,usd: Usd);
    notifyListeners();
  }
}