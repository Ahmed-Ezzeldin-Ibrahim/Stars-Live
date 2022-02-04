import '../controller/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notifications.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.only(bottom: 80),
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            color: Color(0xff393D42),
            child: Text(
              'مرحباً: عبدالله أو زائرنا الكريم',
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          SizedBox(height: 20,),
          //الصفحة الرئيسة
          ListTile(
            onTap: () => Navigator.of(context).pushNamed('/UserPages',arguments: 0),
            leading:  Image(
              image: AssetImage('assets/img/home.png'),
              color: Colors.black,
              width: 30,
              height: 25,
            ),
            title: Text(
              'الصفحة الرئيسة',
              style: GoogleFonts.cairo(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          //الملف الشخصي
          ListTile(
            onTap: () => Navigator.of(context).pushNamed('/UserPages',arguments: 4),
            leading:  Image(
              image: AssetImage('assets/img/user2.png'),
              width: 30,
              height: 25,
            ),
            title: Text(
              'الملف الشخصي',
              style: GoogleFonts.cairo(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          //الطلبات
          ListTile(
            onTap: () => Navigator.of(context).pushNamed('/UserPages',arguments: 1),
            leading:  Image(
              image: AssetImage('assets/img/order1.png'),
              width: 30,
              height: 25,
            ),
            title: Text(
              'الطلبات',
              style: GoogleFonts.cairo(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          //الإشعارات
          ListTile(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsWidget())),
            leading:  Image(
              image: AssetImage('assets/img/notify1.png'),
              // color: Colors.black,
              width: 30,
              height: 25,
            ),
            title: Text(
              'الإشعارات',
              style: GoogleFonts.cairo(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          //عن التطبيق
          ListTile(
            onTap: () => Navigator.of(context).pushNamed('/UserPages',arguments: 0),
            leading:  Image(
              image: AssetImage('assets/img/info.png'),
              color: Colors.black,
              width: 30,
              height: 25,
            ),
            title: Text(
              'عن التطبيق',
              style: GoogleFonts.cairo(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          // شارك التطبيق
          ListTile(
            onTap: () => Navigator.of(context).pushNamed('/UserPages',arguments: 0),
            leading:  Image(
              image: AssetImage('assets/img/share.png'),
              color: Colors.black,
              width: 30,
              height: 25,
            ),
            title: Text(
              'شارك التطبيق',
              style: GoogleFonts.cairo(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          // دخول مقدم الخدمة
          ListTile(
            onTap: () => Navigator.of(context).pushNamed('/UserPages',arguments: 0),
            leading:  Image(
              image: AssetImage('assets/img/mand.png'),
              color: Colors.black,
              width: 30,
              height: 25,
            ),
            title: Text(
              'دخول مقدم الخدمة',
              style: GoogleFonts.cairo(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          // تسجيل الخروج
          ListTile(
            onTap: () => _userController.logOut(context),
            leading:  Image(
              image: AssetImage('assets/img/logout.png'),
              color: Colors.black,
              width: 30,
              height: 25,
            ),
            title: Text(
              'تسجيل الخروج',
              style: GoogleFonts.cairo(
                  color: Color(0xffF61414),
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
        ],
      ),
    );
  }
}
