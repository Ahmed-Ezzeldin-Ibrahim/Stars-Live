import 'package:flutter/cupertino.dart';

import '../model/User.dart';
import '../model/live_user.dart';
import '../repository/user_repository.dart';

class ProfileController extends ChangeNotifier {
  User user;

  getCurrentUserData(BuildContext context) async {
    user = await getUserById(context, userId: currentUser.value.id.toString());
    notifyListeners();
  }
}
