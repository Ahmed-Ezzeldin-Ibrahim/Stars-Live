import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

import '../model/User.dart';
import '../repository/user_repository.dart' as repo;

class UserController extends ChangeNotifier {
  User user = User();

  Future<bool> login(BuildContext context) async {
    print('login btn 4');
    await repo.logIn(context, user: user).then((value) {
      if (value.id != null) {
        print('login btn 5');
        Fluttertoast.showToast(msg: 'تم تسجيل الدخول بنجاح');
        Navigator.pushNamed(context, '/Pages', arguments: 2);
        print('login btn 6');

        return false;
      } else if (value.id == null) {
        Fluttertoast.showToast(msg: 'فشل فى تسجيل الدخول');
        return false;
      }
    });
  }

  Future<void> userRegister(UserController userController, BuildContext context) async {
    await repo.userRegistration(context, user: userController.user).then((value) {
      if (value.id != null) {
        Fluttertoast.showToast(msg: 'تم انشاء الحساب بنجاح');
        final prefs = GetStorage();
        prefs.write('email', '${userController.user.email}');
        prefs.write('password', '${userController.user.password}');

        Navigator.pushReplacementNamed(context, '/Pages', arguments: 2);
      } else {
        Fluttertoast.showToast(msg: 'فشل فى انشاء الحساب');
      }
    });
  }

  Future<bool> googleFaceBookRegister(BuildContext context) async {
    await repo.googleFaceBookRegistration(context, user: user).then((value) async {
      if (value.id != null) {
        Navigator.pushNamedAndRemoveUntil(context, '/Pages', (Route<dynamic> route) => false, arguments: 2);
        return false;
      } else {
        Fluttertoast.showToast(msg: 'فشل فى انشاء الحساب');
        return false;
      }
    });
    return false;
  }

  Future<bool> userUpdateData(BuildContext context) async {
    await repo.userUpdate(context, user: user).then((value) {
      print(value);
      if (value != null) {
        Fluttertoast.showToast(msg: 'تم تحديث البيانات');
        Navigator.pushNamed(context, '/Pages', arguments: 2);
        return false;
      } else {
        // Fluttertoast.showToast(msg: 'فشل فى انشاء الحساب');
        return false;
      }
    });
  }

  logOut(BuildContext context) async {
    await repo.logout().then((value) => Navigator.of(context).pushNamed('/Login'));
  }
}
