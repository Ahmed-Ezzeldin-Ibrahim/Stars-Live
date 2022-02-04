import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../repository/network_profile.dart';
import '../repository/profile_response.dart';

import '../constant/contant.dart';
import '../controller/profie_controller.dart';
import '../controller/user_controller.dart';
import '../provider/AppLanguage.dart';
import '../widget/LoadingScreen.dart';
import '../widget/level_color.dart';
import 'diamond.dart';
import 'followers.dart';
import 'income.dart';
import 'settings.dart';
import 'updata_user_data.dart';
import 'user_level.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // var applocal = AppLocalizations.of(context);
    final langProvider = Provider.of<AppLanguage>(context);
    return Scaffold(
        body: FutureBuilder<ProfileResponse>(
      future: networkGetProfile(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
        if (snapshot.error != null)
          return Column(
            children: [
              Text('${snapshot.error}'),
            ],
          );

        return LoadingScreen(
          loading: loading,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: h * 1.2,
                  width: w,
                ),
                Container(
                  height: 250,
                  width: w,
                  decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))),
                ),
                Positioned(
                    top: 80,
                    child: InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (contex) => UpdateUserData())),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          'assets/img/edit_user.png',
                          color: Colors.white,
                        ),
                      ),
                    )),
                Positioned(
                    top: 130,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 250,
                      width: w - 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: SizedBox(width: 2)),
                              Text(
                                snapshot.data.data[0].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 8),
                              LevelColors(
                                level: snapshot.data.data[0].levelUser == null ? 0 : snapshot.data.data[0].levelUser.level,
                              ),
                              Container(
                                  width: 60,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xffFFC700),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star_border,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        snapshot.data.data[0].levelUser == null ? '1' : '${snapshot.data.data[0].levelUser.level}',
                                        style: TextStyle(fontSize: 10, color: Colors.white),
                                      ),
                                    ],
                                  )),
                              Expanded(child: SizedBox(width: 2)),
                            ],
                          ), 
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '# ${snapshot.data.data[0].id}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17, color: Color(0xffC1C0C9), fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 0,
                            decoration: BoxDecoration(border: Border.all(color: baseColor.withOpacity(.2))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _followingsAndFolloersWidget(),
                        ],
                      ),
                    )),
                Positioned(
                  top: 80,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(image: snapshot.data.data[0].image == null ? AssetImage('assets/img/person.png') : NetworkImage(snapshot.data.data[0].image), fit: BoxFit.contain)),
                  ),
                ),
                Positioned(
                    top: 400,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 600,
                      width: w - 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                      // padding: EdgeInsets.only(bottom: 60),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          helpRow(title: localized(context, 'diamonds'), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiamondWidget()))),
                          levelRow(
                              level: snapshot.data.data[0].levelUser != null ? snapshot.data.data[0].levelUser.level : 1,
                              title: localized(context, 'level'),
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserLevel()))),
                          helpRow(title: localized(context, 'income'), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => IncomeWidget()))),
                          helpRow(title: localized(context, 'customer_service'), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsWidget()))),
                          helpRow(
                              title: localized(context, 'settings'),
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SettingsWidget(
                                        languageProvider: langProvider,
                                      )))),
                          helpRow(
                            title: localized(context, 'log_out'),
                            iconStatus: false,
                            onTap: () async {
                              loading = true;
                              final prefs = GetStorage();
                              prefs.remove('email');
                              Navigator.of(context).pushReplacementNamed('/Login');
                              UserController userCont = UserController();
                              userCont.logOut(context).whenComplete(() => loading = false);
                            },
                          ),
                          SizedBox(
                            height: 90,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    ));
  }

  levelRow({String title, Function onTap, @required int level}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 0,
          shape: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LevelColors(
                      level: level == null ? 1 : level,
                    ),
                  ],
                ),
                IconButton(
                    icon: RotatedBox(
                        quarterTurns: 2,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        )),
                    onPressed: onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  helpRow({String title, Function onTap, bool iconStatus = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 0,
          shape: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                !iconStatus
                    ? SizedBox(
                        width: 0,
                      )
                    : IconButton(
                        icon: RotatedBox(
                            quarterTurns: 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            )),
                        onPressed: onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _followingsAndFolloersWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Provider.of<ProfileController>(context).user != null)
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return FollowersWidget(
                      titleOfPopUp: localized(context, 'following'),
                      following: Provider.of<ProfileController>(context).user.followeds,
                    );
                  });
            },
            child: Column(
              children: [
                Text(
                  localized(context, 'following').toString(),
                  style: TextStyle(color: Color(0xffC1C0C9), fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  Provider.of<ProfileController>(context).user.followed == null ? "0" : Provider.of<ProfileController>(context).user.followeds.length.toString(),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 17),
                )
              ],
            ),
          ),
        SizedBox(
          width: 100,
        ),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return FollowersWidget(
                    titleOfPopUp: localized(context, 'followers'),
                    following: Provider.of<ProfileController>(context).user.followers,
                  );
                });
          },
          child: Column(
            children: [
              Text(
                localized(context, 'followers').toString(),
                style: TextStyle(color: Color(0xffC1C0C9), fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              if (Provider.of<ProfileController>(context).user != null)
                Text(
                  Provider.of<ProfileController>(context).user.followers == null ? "0" : Provider.of<ProfileController>(context).user.followers.length.toString(),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 17),
                )
            ],
          ),
        ),
      ],
    );
  }
}
