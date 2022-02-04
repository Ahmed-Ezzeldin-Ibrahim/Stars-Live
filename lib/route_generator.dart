import 'package:flutter/material.dart';
import 'view/pages.dart';
import 'view/splash_screan.dart';

import 'view/login.dart';
import 'view/profile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LogIn());
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfileWidget());

      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesTestWidget(currentTab: args));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                    body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Invalid route'),
                  ],
                )));
    }
  }
}
