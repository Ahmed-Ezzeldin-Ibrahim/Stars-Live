import 'package:flutter/cupertino.dart';

import '../model/User.dart';
import '../repository/SearchRepository.dart';
import '../repository/chats_repository.dart';

class SearchProvider extends ChangeNotifier {
  User user;

  getSearchUser(BuildContext context,{String id}) async {
    user = await getUserById(context, userId: id);
    notifyListeners();
  }

  String getUserName() {
    return user.name;
  }

  String getUserImage() {
    return user.image;
  }

  int getUserLevel() {
    return user.userLevel.level;
  }

  User getSearched() {
    return user;
  }
}
