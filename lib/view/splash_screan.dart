import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../controller/profie_controller.dart';
import '../helper/echo.dart';
import '../main_provider_model.dart';
import '../provider/splash_provider.dart';
import '../repository/user_repository.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _nextStep() async {
    await Future.delayed(Duration(seconds: 1));

    final prefs = GetStorage();
    int userId = prefs.read('current_user_id');
    Echo('splash userId $userId');
    if (userId != null) {
      try {
        currentUser.value.id = prefs.read('current_user_id');
        currentUser.value.name = prefs.read('current_user_name');
        currentUser.value.email = prefs.read('current_user_email');
        currentUser.value.phone = prefs.read('current_user_phone');
        currentUser.value.image = prefs.read('current_user_image');
        currentUser.value.gender = prefs.read('current_user_gender');
        currentUser.value.country = prefs.read('current_user_country');
        currentUser.value.apiToken = prefs.read('current_user_apiToken');
        currentUser.value.latitude = prefs.read('current_user_latitude');
        currentUser.value.longitude = prefs.read('current_user_longitude');
        currentUser.value.deviceToken = prefs.read('current_user_deviceToken');
        currentUser.value.balanceInCoins = prefs.read('current_user_coins');
        await Provider.of<ProfileController>(context, listen: false).getCurrentUserData(context);
        Provider.of<MainProviderModel>(context, listen: false).profileData = currentUser.value;
        Navigator.pushReplacementNamed(context, '/Pages', arguments: 2);
      } catch (e) {
        Echo('error $e');
        Navigator.of(context).pushReplacementNamed('/Login');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/Login');
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _nextStep());
  }

  getSplashData() async {
    return;
    if (Provider.of<SplashProvider>(context).s == null) {
      await Provider.of<SplashProvider>(context, listen: false).getSplash();
      print(Provider.of<SplashProvider>(context, listen: false).s.status);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // var applocal = AppLocalizations.of(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: h / 4,
              width: double.infinity,
            ),
            Image.asset(
              'assets/img/logo.png',
              height: w / 1.4,
            ),
            SizedBox(height: h / 10),
            CircularProgressIndicator(),
          ],
        )
        //buildContainer(w, context, r),
        );
  }
}
