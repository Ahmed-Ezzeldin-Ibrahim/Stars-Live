import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart' as per;
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart' as wake;

import '../constant/contant.dart';
import '../helper/echo.dart';
import '../main_provider_model.dart';
import '../model/live_user.dart';
import '../provider/banner_provider.dart';
import '../provider/get_live_user.dart';
import '../repository/network_profile.dart';
import '../repository/user_repository.dart';
import 'broodcast.dart';
import 'buy.dart';
import 'golden_crown.dart';
import 'join.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  int currentIndex;
  HomeWidget({Key key, this.parentScaffoldKey, this.currentIndex = 1}) : super(key: key);
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool ready = false;
  int userId;
  int coins;
  int level;
  String image = 'https://nichemodels.co/wp-content/uploads/2019/03/user-dummy-pic.png';
  String username;
  String postUsername;

  Future<void> loadSharedPref() async {}

  @override
  void initState() {
    super.initState();
    wake.Wakelock.enable();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 2;
  final double expanded = 200;

  getBannerData() async {
    if (Provider.of<BannerProvider>(context).b == null) {
      await Provider.of<BannerProvider>(context, listen: false).getBanners().whenComplete(() => setState(() {
            print(Provider.of<BannerProvider>(context, listen: false).b.data[0].image);
          }));
      //print(Provider.of<BannerProvider>(context, listen: false).b.status);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: getHomeData(),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return SafeArea(
                child: NestedScrollView(
                    headerSliverBuilder: (context, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          floating: false,
                          pinned: true,
                          snap: false,
                          forceElevated: innerBoxIsScrolled,
                          backgroundColor: baseColor,
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          primary: true,
                          leading: InkWell(
                            onTap: () async {
                              bool ccreate = await canCreate();
                              if (!ccreate) {
                                Fluttertoast.showToast(msg: 'camera & mic permission required to continue');
                                return;
                              } else {
                                final prefs = GetStorage();
                                setState(() {
                                  // level = prefs.getString('current_user_level') ?? '66';
                                  username = currentUser.value.name;
                                  coins = prefs.read('current_user_coins') ?? "10";
                                  userId = prefs.read('current_user_id');
                                  image = prefs.read('current_user_image') ?? 'https://nichemodels.co/wp-content/uploads/2019/03/user-dummy-pic.png';
                                });
                                await onCreate(
                                  username: username,
                                  channelName: userId.toString(),
                                  image: image,
                                  coins: coins,
                                  userId: userId,
                                );
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: baseColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: baseColor, width: 5),
                              ),
                              child: Image.asset(
                                'assets/img/video.png',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              height: 50,
                              width: w,
                              color: baseColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          _index = 1;
                                        });
                                      },
                                      child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _index == 1 ? Color(0xffFFC700) : baseColor, width: 3))),
                                          child: Text(
                                            localized(context, 'Followers'),
                                            style: TextStyle(fontSize: 17, color: Colors.white),
                                          ))),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          _index = 2;
                                        });
                                      },
                                      child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _index == 2 ? Color(0xffFFC700) : baseColor, width: 3))),
                                          child: Text(
                                            localized(context, 'Commen'),
                                            style: TextStyle(fontSize: 17, color: Colors.white),
                                          ))),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GoldenCrown()));
                                    },
                                    child: Image.asset(
                                      'assets/img/tag.png',
                                      height: 25,
                                      width: 25,
                                      color: Color(0xffFFFF4A),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuyScreen()));
                                        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
                                      }
                                      //
                                      ),
                                  /*InkWell(
                                  onTap: () {
                                    setState(() {
                                      _index = 3;
                                    });
                                  },
                                  child: Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: _index == 3
                                                      ? Color(0xffFFC700)
                                                      : baseColor,
                                                  width: 3))),
                                      child: Text(
                                        localized(context, 'my_voice'),
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ))),*/
                                ],
                              )),
                          elevation: 0,
                          expandedHeight: expanded - top,
                          actions: [],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              height: expanded,
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(top: 60),
                              child: Column(
                                children: [
                                  Provider.of<BannerProvider>(context, listen: false).b == null
                                      ? CircularProgressIndicator()
                                      : Container(
                                          height: 100,
                                          width: w,
                                          child: CarouselSlider(
                                            options: CarouselOptions(
                                              autoPlay: true,
                                              enlargeCenterPage: true,
                                              enableInfiniteScroll: true,
                                              height: 100,
                                              viewportFraction: 1.0,
                                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                                            ),
                                            items: List.generate(Provider.of<BannerProvider>(context).b.data.length, (index) {
                                              return InkWell(
                                                onTap: () {},
                                                // onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                                                //     builder: (context)=> ShowImagesWidget(
                                                //       images: .map((e) => e.image).toList(),
                                                //       currentIndex: index,
                                                //     )
                                                // )),
                                                child: Container(
                                                  width: w,
                                                  color: Color.fromRGBO(41, 57, 101, .5),
                                                  child: Image.network(
                                                    Provider.of<BannerProvider>(context).b.data[index].image,
                                                    height: 150,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ];
                    },
                    body: ChangeNotifierProvider(
                      create: (_) => GetLiveUsers(),
                      child: Consumer<GetLiveUsers>(
                        builder: (BuildContext context, liveUsers, child) {
                          if (liveUsers.liveuser == null || liveUsers.liveuser.data == null) return Container();
                          return Conditional.single(
                            context: context,
                            conditionBuilder: (context) => liveUsers.liveuser != null,
                            fallbackBuilder: (context) => Center(child: CircularProgressIndicator()),
                            widgetBuilder: (context) => Conditional.single(
                              context: context,
                              conditionBuilder: (context) => liveUsers.liveuser.data.isNotEmpty,
                              widgetBuilder: (context) => _buildWidgetView(liveUsers.liveuser),
                              fallbackBuilder: (context) => Center(child: Text("لا يوجد بث مباشر في الوقت الحالي", style: TextStyle(color: Colors.black))),
                            ),
                          );
                        },
                      ),
                    )),
              );
            else if (snapshot.hasError)
              return GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                      ),
                      if (kDebugMode) Text('${snapshot.error}'),
                      Text("انترنت ضعيف او لايوجد اتصال بالانترنت", style: TextStyle(color: Colors.black)),
                      SizedBox(height: 12),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black,
                          ),
                          child: Text("اعادة المحاولة", style: TextStyle(color: Colors.white))),
                    ],
                  ),
                ),
              );
            else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Future<bool> getHomeData() async {
    await getBannerData();
    await networkGetProfile(context);
    return true;
  }

  _buildWidgetView(LiveRoomsResponse liveusers) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 3 / 3),
      itemCount: liveusers.data.length,
      itemBuilder: (context, index) {
        return InkWell(
            child: liveUserWidget(liveusers.data[index]),
            onTap: () {
              onJoin(
                channelName: liveusers.data[index].id,
                channelId: liveusers.data[index].id,
                liveUser: liveusers.data[index],
              );
            });
      },
    );
  }

  Future<void> onJoin({channelName, channelId, LiveUserData liveUser}) async {
    // GetTokenResponse response = await networkGetUserToken('${liveUser.id}');
    final prefs = GetStorage();
    setState(() {
      username = currentUser.value.name;
      coins = prefs.read('current_user_coins') ?? "10";
      userId = currentUser.value.id;
      image = currentUser.value.image;
    });
    // await getToken(channelName);
    // print(agoraToken);
    setState(() {
      agoraToken = agoraToken;
    });
    // update input validation
    if ('$channelName'.isNotEmpty) {
      // push video page with given channel name
      MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinPage(
            liveUser: liveUser,
            profile: mainProviderModel.profileResponse.data.first,
            token: '',
            // token: '${response.data.liveToken}',
          ),
        ),
      );
    }
  }

  Future<bool> canCreate() async {
    per.Permission cameraStatus = per.Permission.camera;
    if (!await cameraStatus.isGranted) await cameraStatus.request();
    // print(status);
    if (await cameraStatus.isDenied) return false;
    if (await cameraStatus.isRestricted) return false;
    if (await cameraStatus.isPermanentlyDenied) return false;
    if (await cameraStatus.isGranted) {
      print('mic allowed');
    }
    per.Permission micStatus = per.Permission.microphone;
    if (!await micStatus.isGranted) await micStatus.request();
    if (await micStatus.isDenied) return false;
    if (await micStatus.isRestricted) return false;
    if (await micStatus.isPermanentlyDenied) return false;
    if (await micStatus.isGranted) {
      print('mic allowed');
    }
    bool doseCameraAllowerd = await cameraStatus.isGranted;
    bool doseMicAllowed = await micStatus.isGranted;
    if (doseCameraAllowerd && doseMicAllowed)
      return true;
    else
      return false;
  }

  Future<void> onCreate({
    String username,
    String image,
    String channelName,
    int coins,
    int userId,
  }) async {
    // await for camera and mic permissions before pushing video page
    // LoadingDialog loading = LoadingDialog(buildContext: context);
    // loading.show();

    // loading.hide();
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
    Echo('${mainProviderModel.profileResponse.data.length}');
    // if (false)
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Broadcast(
          role: ClientRole.Broadcaster,
          profile: mainProviderModel.profileResponse.data.first,
        ),
        /* BroadcastPage(
          channelName: username,
          time: currentTime,
          image: image,
        ),*/
      ),
    );
  }

  _FollwersWidgetView() {
    return Expanded(
      child: Center(
        child: Text('Followers'),
      ),
    );
  }

  _gamesWidgetView() {
    return Expanded(
      child: Center(
        child: Text('we will develop later'),
      ),
    );
  }

  liveUserWidget(LiveUserData user) {
    return Container(
      height: 190,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: CachedNetworkImage(
              imageUrl: user.image != null ? user.image : '',
              errorWidget: (context, url, error) {
                return Icon(
                  Icons.person,
                  size: 140,
                  color: Colors.grey,
                );
              },
            ),
          ),
          Positioned(
            top: 5,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Color(0xff4A4A4A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/fire.png',
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "0",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ],
                )),
          ),
          Positioned(
            bottom: 5,
            width: (MediaQuery.of(context).size.width / 2) - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      user.name,
                      style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amber,
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
                          '15',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
