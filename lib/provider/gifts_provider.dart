import 'package:flutter/material.dart';

import '../model/gifts.dart';
import '../repository/gifts_repository.dart';

class GiftsProvider extends ChangeNotifier {
  Gifts gifts;

  GiftsProvider() {
    getUserGifts();
  }

  getUserGifts() async {
    gifts = await getGifts();
    notifyListeners();
  }

  sendUserGifts({receiverId, giftId}) async {
    sendGifts(recieverId: receiverId, giftId: giftId);
  }
}
