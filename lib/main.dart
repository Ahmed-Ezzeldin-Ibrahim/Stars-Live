// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:starslive/main_provider_model.dart';
import 'package:starslive/repository/user_repository.dart';

import 'controller/profie_controller.dart';
import 'localization/AppLocalizations.dart';
import 'provider/AppLanguage.dart';
import 'provider/BuyProvider.dart';
import 'provider/SearchProvider.dart';
import 'provider/banner_provider.dart';
import 'provider/chats_provider.dart';
import 'provider/gifts_provider.dart';
import 'provider/splash_provider.dart';
import 'provider/top_users_provider.dart';
import 'route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getCurrentUser();
  await GetStorage.init();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();

  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLanguage>(
          create: (_) => widget.appLanguage,
        ),
        ChangeNotifierProvider<AppLanguage>(
          create: (_) => widget.appLanguage,
        ),
        ChangeNotifierProvider<MainProviderModel>(
          create: (_) => MainProviderModel(),
        ),
        ChangeNotifierProvider<ProfileController>(
          create: (_) => ProfileController(),
        ),
        ChangeNotifierProvider<GiftsProvider>(
          create: (_) => GiftsProvider(),
        ),
        ChangeNotifierProvider<TopUsersProvider>(
          create: (_) => TopUsersProvider(),
        ),
        ChangeNotifierProvider<ChatsProvider>(
          create: (_) => ChatsProvider(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => SearchProvider(),
        ),
        ChangeNotifierProvider<BannerProvider>(
          create: (_) => BannerProvider(),
        ),
        ChangeNotifierProvider<BuyProvider>(
          create: (_) => BuyProvider(),
        ),
        ChangeNotifierProvider<SplashProvider>(
          create: (_) => SplashProvider(),
        ),
        //SplashProvider
      ],
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          title: 'Stars Live',
          theme: ThemeData(
            primarySwatch: Colors.brown,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/Splash',
          onGenerateRoute: RouteGenerator.generateRoute,
          locale: Locale('ar'),
          supportedLocales: [Locale('en', 'US'), Locale('ar', '')],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      }),
    );
  }
}
