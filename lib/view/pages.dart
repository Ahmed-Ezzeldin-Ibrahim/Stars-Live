import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../chat_list/chat_list.dart';

import '../constant/contant.dart';
import '../model/route_argument.dart';
import 'games.dart';
import 'home.dart';
import 'notifications.dart';
import 'profile.dart';

// ignore: must_be_immutable
class PagesTestWidget extends StatefulWidget {
  dynamic currentTab;
  DateTime currentBackPressTime;
  RouteArgument routeArgument;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesTestWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 2;
    }
  }

  @override
  _PagesTestWidgetState createState() {
    return _PagesTestWidgetState();
  }
}

class _PagesTestWidgetState extends State<PagesTestWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesTestWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem; // == 3 ? 1 : tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = GamesWidget();
          break;
        case 1:
          widget.currentPage = ContactsScreen();
          // MarketsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 2:
          widget.currentPage = HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          widget.currentPage = ProfileWidget();

          break;
        case 4:
          widget.currentPage = NotificationsWidget();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: widget.scaffoldKey,
        body: widget.currentPage,
        // floatingActionButton: Container(
        //   height: 65,
        //   width: 65,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     shape: BoxShape.circle,
        //     border: Border.all(color: Colors.transparent, width: 5),
        //   ),
        //   child: FittedBox(
        //     child: FloatingActionButton(
        //       backgroundColor: baseColor,
        //       onPressed: (){
        //       },
        //       child: Image.asset('assets/img/video.png'),
        //       // elevation: 5.0,
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          height: h * .1,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedItemColor: baseColor,
            unselectedItemColor: Color(0xffC0C0C0),
            selectedLabelStyle: GoogleFonts.cairo(fontSize: 10, color: baseColor),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 8.0, color: Colors.white),
            backgroundColor: Colors.white,
            currentIndex: widget.currentTab,
            onTap: (int i) {
              print(i);
              this._selectTab(i);
            },
            // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage('assets/img/games.png'),
                  height: h * .035,
                  width: 30,
                  color: widget.currentTab == 0 ? baseColor : Color(0xffC0C0C0),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                  icon: Container(
                    child: Image(
                      image: AssetImage('assets/img/chat.png'),
                      height: h * .035,
                      width: 30,
                      color: widget.currentTab == 1 ? baseColor : Color(0xffC0C0C0),
                    ),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage('assets/img/home.png'),
                  height: h * .035,
                  width: 30,
                  color: widget.currentTab == 2 ? baseColor : Color(0xffC0C0C0),
                ),
                label: '',
              ),
              /* BottomNavigationBarItem(
                  icon: Container(
                    child: Image.asset(
                      'assets/img/notify.png',
                      height: h * .035,
                      width: 40,
                      color: widget.currentTab == 3
                          ? baseColor
                          : Color(0xffC0C0C0),
                    ),
                  ),
                  label: ''), */
              BottomNavigationBarItem(
                icon: Container(
                  child: Image(
                    image: AssetImage('assets/img/user.png'),
                    height: h * .035,
                    width: 30,
                    color: widget.currentTab == 3 ? baseColor : Color(0xffC0C0C0),
                  ),
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (widget.currentBackPressTime == null || now.difference(widget.currentBackPressTime) > Duration(seconds: 2)) {
      widget.currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'اسحب مرة اخري للخروج');
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }
}
