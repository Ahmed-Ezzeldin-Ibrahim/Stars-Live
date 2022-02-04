import 'package:flutter/material.dart';
import '../model/top_users.dart';
import '../repository/gifts_repository.dart';
import '../repository/top_users_repository.dart';

class TopUsersProvider extends ChangeNotifier {
  TopUsersProvider() {
    getGiftSenderByYear();
    getGiftSenderByMonth();
    getGiftSenderByDay();
    getGiftRecieverByYear();
    getGiftRecieverByMonth();
    getGiftRecieverByDay();
    getAllTopSupporter();
    getDayTopSupporter();
    getShiftTopSupporter();
  }
  TopUsers yearlyTopUsers, monthlyTopUsers, todayTopUsers;

  void getGiftSenderByYear() async {
    yearlyTopUsers = await giftSenders("this_year");
    notifyListeners();
  }

  void getGiftSenderByMonth() async {
    monthlyTopUsers = await giftSenders("this_month");
    notifyListeners();
  }

  void getGiftSenderByDay() async {
    todayTopUsers = await giftSenders("today");
    notifyListeners();
  }

  /* TOP RECIEVERS USERS */
  TopUsers yearlyTopReceiversUsers,
      monthlyTopReceiversUsers,
      todayTopReceiversUsers;
  void getGiftRecieverByYear() async {
    yearlyTopReceiversUsers = await giftRecievers("this_year");
    notifyListeners();
  }

  void getGiftRecieverByMonth() async {
    monthlyTopReceiversUsers = await giftRecievers("this_month");
    notifyListeners();
  }

  void getGiftRecieverByDay() async {
    todayTopReceiversUsers = await giftRecievers("today");
    notifyListeners();
  }

  /* TOP SUPPORTERS USERS */
  TopUsers allSupporters, todaySupporters, shiftSupporters;
  void getAllTopSupporter() async {
    allSupporters = await getSupporters("all");
    notifyListeners();
  }

  void getDayTopSupporter() async {
    todaySupporters = await getSupporters("today");
    notifyListeners();
  }

  void getShiftTopSupporter() async {
    shiftSupporters = await getSupporters("this_shift");
    notifyListeners();
  }
}
