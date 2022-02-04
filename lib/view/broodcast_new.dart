import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../helper/echo.dart';

import '../constant/contant.dart';
import '../controller/profie_controller.dart';
import '../model/broad_cast_user.dart';
import '../model/menu_item.dart';
import '../model/message.dart';
import '../repository/user_repository.dart';
import '../widget/top_users/supporters/all_supporters.dart';
import '../widget/top_users/supporters/shift_supporters.dart';
import '../widget/top_users/supporters/today_supporters.dart';

class BroadcastNew extends StatefulWidget {
  final String channelName;
  final String userName;
  final String coins;
  final int userId;
  final String image;
  final ClientRole role;

  const BroadcastNew({
    Key key,
    @required this.channelName,
    @required this.role,
    @required this.image,
    @required this.userName,
    @required this.userId,
    @required this.coins,
  }) : super(key: key);

  @override
  _BroadcastNewPageState createState() => _BroadcastNewPageState();
}

class _BroadcastNewPageState extends State<BroadcastNew> {
  ClientRole currentUserRole = ClientRole.Audience;
  final _users = <int>[];

  final List<BroadCastUser> userList = [];
  final List<Message> messages = [];
  final List<String> _infoStrings = [];
  int streamId;
  int userNo = 0;

  bool tryingToEnd = false;
  bool _isInChannel = false;
  bool personBool = false;
  bool anyPerson = false;
  bool _isLogin = false;
  bool accepted = false;
  bool waiting = false;
  bool muted = false;
  bool ontap = false;

  var userMap;
  TextEditingController _channelMessageController = TextEditingController();
  ProfileController profileController = ProfileController();
  RtcEngine _engine;
  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  // User joinedUser;
  bool showui = false;
  final _kTabs = <Widget>[
    Container(
      child: const Tab(
        text: 'اليوم الحالي',
      ),
    ),
    Container(
      child: const Tab(
        text: 'الشيفت الحالي',
      ),
    ),
    Container(
      child: const Tab(
        text: 'الكل',
      ),
    ),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    currentUserRole = widget.role;
    showui = false;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  init() async {
    await createToken(widget.channelName);
    await initializeAgora();
    await _createClient();
    await setLiveUser("1");
    userMap = {widget.channelName: widget.image};
    showui = true;
    setState(() {});
  }

  Future<void> initializeAgora() async {
    Echo("CHANNEL NAME IS ---------------- ${widget.channelName}");
    Echo("CHANNEL TOKEN IS ---------------- $agoraToken");
    await _initAgoraRtcEngine();
    await _engine.joinChannel(agoraToken, widget.channelName, null, currentUser.value.id);

    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) async {
        setState(() {
          var info = "onJoinChannel: $channel, uid: $uid";
          _infoStrings.add(info);
          Echo(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          var info = "message onLeaveChannel";
          _infoStrings.add(info);
          Echo('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) async {
        await getChannelCount();
        setState(() {
          var info = "userJoined: $uid";
          _infoStrings.add(info);
          sendChannelMessage(info: 'Member joined: ', user: widget.userName, type: 'join');
          Echo('userJoined From Host: $uid');
          _users.add(uid);
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          Echo('userOffline: $uid');
          _users.remove(uid);
        });
      },
      streamMessage: (_, __, message) {
        final String info = "here is the message $message";
        Echo(info);
      },
      streamMessageError: (_, __, error, ___, ____) {
        final String info = "here is the error $error";
        Echo(info);
      },
      tokenPrivilegeWillExpire: (token) async {
        // await getToken(widget.userName);
        await _engine.renewToken(token);
      },
    ));
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);

    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  Future _createClient() async {
    _client = await AgoraRtmClient.createInstance(chatId);
    final prefs = GetStorage();
    int userId = currentUser.value.id;
    _client.login(null, userId.toString()).then((value) {
      Echo("User Logged IN ");
      setState(() {
        _isInChannel = true;
        _isLogin = true;
      });
    });
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      sendChannelMessage(user: peerId, info: message.text, type: 'message');
    };
    //testing
    _client.onConnectionStateChanged = (int state, int reason) {
      Echo("agora Connection State ${state.toString()}");
      if (state == 5) {
        _client.logout();
        //sendChannelMessage('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    await _createChannel(widget.channelName);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: showui == false
            ? new Center(child: CircularProgressIndicator())
            : Center(
                child: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      _broadcastView(),
                      if (tryingToEnd == false && widget.role == ClientRole.Broadcaster)
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Column(
                            children: [
                              _endCall(),
                              switchCamera(),
                              muteMic(),
                            ],
                          ),
                        ),
                      if (tryingToEnd == false)
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _userImage(),
                                if (widget.role == ClientRole.Broadcaster) _guestsList(),
                                if (widget.role == ClientRole.Broadcaster)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _usersImage(),
                                      _usersCount(),
                                    ],
                                  ),
                              ],
                            ),
                            _showUserName(),
                            _userLevel(),
                          ],
                        ),
                      if (tryingToEnd == false) _bottomBar(context),
                      if (tryingToEnd == false) messageList(),
                      // if (tryingToEnd == true) endLive(),
                      if (personBool == true && waiting == false) personList(),
                      if (accepted == true) stopSharing(),
                      if (waiting == true) guestWaiting(),
                    ],
                  ),
                ),
              ),
      ),
      onWillPop: _willPopCallback,
    );
  }

  Widget _usersImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
            gradient: LinearGradient(
              colors: <Color>[Colors.orange, Colors.blue],
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Row(
            children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.black,
                  shape: BoxShape.circle,
                  image: DecorationImage(image: currentUser.value.image == null ? AssetImage('assets/img/person.png') : NetworkImage(currentUser.value.image), fit: BoxFit.contain)),
            ),
          ),
        ).toList()),
      ),
    );
  }

  Widget _endCall() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            if (personBool == true) {
              setState(() {
                personBool = false;
              });
            }
            setState(() {
              if (waiting == true) {
                waiting = false;
              }
              tryingToEnd = true;
            });
          },
          child: Icon(
            Icons.cancel,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _usersCount() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(.6), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                height: 28,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        EvaIcons.person,
                        color: Colors.white,
                        size: 13,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$userNo',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(context) {
    if (!_isLogin || !_isInChannel) {
      return Container();
    } //TODO::There is problem Here
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextField(
                  controller: _channelMessageController,
                  decoration: InputDecoration(
                    hintText: 'اكتب رسالتك ...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    hintStyle: TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      onPressed: _toggleSendChannelMessage,
                      icon: Icon(
                        Icons.send,
                        color: Colors.black12,
                      ),
                    ),
                    hoverColor: Colors.grey,
                    fillColor: Colors.grey,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Container(
          width: 150,
          child: Row(
            children: [
              Icon(
                item.icon,
                color: Colors.blue[400],
                size: 15.0,
              ),
              const SizedBox(width: 10),
              Text(item.text),
            ],
          ),
        ),
      );

  Widget _guestsList() {
    return Container();
    return Positioned(
      right: 110,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
        child: MaterialButton(
          minWidth: 0,
          onPressed: () {
            setState(() {
              personBool = !personBool;
            });
          },
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ),
    );
  }

  Widget messageList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              if (messages.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: (messages[index].type == 'join')
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '${messages[index].user} joined',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : (messages[index].type == 'message')
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10, right: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: messages[index].image ?? "",
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: 32.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        messages[index].user,
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        messages[index].message,
                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : null,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget personList() {
    // return Container();
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 2 * MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 2 * MediaQuery.of(context).size.height / 3 - 50,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Text(
                      'Go Live with',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.grey[800],
                    thickness: 0.5,
                    height: 0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    width: double.infinity,
                    color: Colors.grey[900],
                    child: Text(
                      'When you go live with someone, anyone who can watch their live videos will be able to watch it too.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  anyPerson == true
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          width: double.maxFinite,
                          child: Text(
                            'INVITE',
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ))
                      : Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'No Viewers',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                  Expanded(
                    child: ListView(shrinkWrap: true, scrollDirection: Axis.vertical, children: getUserStories()),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    personBool = !personBool;
                  });
                },
                child: Container(
                  color: Colors.grey[850],
                  alignment: Alignment.bottomCenter,
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: double.maxFinite,
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget guestWaiting() {
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
          height: 100,
          width: double.maxFinite,
          alignment: Alignment.center,
          color: Colors.black,
          child: Wrap(
            children: <Widget>[
              Text(
                'Waiting for the user to accept...',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          )),
    );
  }

  Widget stopSharing() {
    return Container(
      height: MediaQuery.of(context).size.height / 2 + 40,
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: MaterialButton(
          minWidth: 0,
          onPressed: () async {
            setState(() {
              accepted = false;
            });
            await _channel.sendMessage(AgoraRtmMessage.fromText('E1m2I3l4i5E6 stoping'));
          },
          child: Icon(
            Icons.clear,
            color: Colors.white,
            size: 15.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          color: Colors.blue[400],
          padding: const EdgeInsets.all(5.0),
        ),
      ),
    );
  }

  Widget _userImage() {
    return Positioned(
      right: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.0),
              gradient: LinearGradient(
                colors: <Color>[Colors.orange, Colors.blue],
              ),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: Colors.black,
                shape: BoxShape.circle,
                image: DecorationImage(image: currentUser.value.image == null ? AssetImage('assets/img/person.png') : NetworkImage(currentUser.value.image), fit: BoxFit.contain)),
          ),
        ),
      ),
    );
  }

  Widget _showUserName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
            gradient: LinearGradient(
              colors: <Color>[Colors.orange, Colors.blue],
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: Row(
            children: [
              Text(
                currentUser.value.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userLevel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            decoration: BoxDecoration(
                color: Colors.orange,
                gradient: LinearGradient(
                  colors: <Color>[Colors.deepOrange.shade400, Colors.orangeAccent],
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Text(
              currentUser.value.userHostLevel == null ? "1" : "${currentUser.value.userHostLevel.level}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(color: Colors.black26.withOpacity(.6), borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: GestureDetector(
                onTap: SetBttom,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset('assets/img/diamond1.png', width: 15, fit: BoxFit.contain),
                      SizedBox(width: 4),
                      Text(
                        currentUser.value.diamonds == null ? "0" : currentUser.value.diamonds.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SetBttom() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  leading: Container(),
                  title: const Text('الماسات'),
                  centerTitle: true,
                  backgroundColor: Colors.purpleAccent.shade400,
                  bottom: TabBar(
                    tabs: _kTabs,
                  ),
                ),
                body: TabBarView(
                  children: [
                    TodaySupporters(),
                    ShiftSupporters(),
                    AllSupporters(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<bool> _willPopCallback() async {
    if (widget.role != ClientRole.Broadcaster) return true;

    if (personBool == true) {
      setState(() {
        personBool = false;
      });
    } else {
      setState(() {
        tryingToEnd = !tryingToEnd;
      });
    }

    return false; // return true if the route to be popped
  }

  Future<void> sendChannelMessageout() async {
    try {
      await _client.logout();
      //sendChannelMessage(info:'Logout success.',type: 'logout');
    } catch (errorCode) {
      //sendChannelMessage(info: 'Logout error: ' + errorCode.toString(), type: 'error');
    }
  }

  Future<void> _leaveChannel() async {
    try {
      await _channel.leave();
      //sendChannelMessage(info: 'Leave channel success.',type: 'leave');
      _client.releaseChannel(_channel.channelId);
      _channelMessageController.text = null;
    } catch (errorCode) {
      // sendChannelMessage(info: 'Leave channel error: ' + errorCode.toString(),type: 'error');
    }
  }

  List<Widget> getUserStories() {
    List<Widget> stories = [];
    for (BroadCastUser users in userList) {
      stories.add(getStory(users));
    }
    Echo("USER LIST IS ________________ $userList");
    return stories;
  }

  Widget getStory(BroadCastUser users) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              setState(() {
                waiting = true;
              });
              await _channel.sendMessage(AgoraRtmMessage.fromText('d1a2v3i4s5h6 ${users.name}'));
            },
            child: Container(
                padding: EdgeInsets.only(left: 15),
                color: Colors.grey[850],
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: users.image,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: <Widget>[
                          Text(
                            users.name,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            users.name,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (currentUserRole == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));

    return list;
  }

  /// Video view row wrapper
  Widget _expandedVideoView(List<Widget> views) {
    final wrappedViews = views.map<Widget>((view) => Expanded(child: Container(child: view))).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _broadcastView() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoView(
              [views[0]],
            ),
          ],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoView([views[0]]),
            _expandedVideoView([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 3))],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 4))],
        ));
      default:
    }
    return Container();
  }

  void _onSwitchCamera() {
    // if (streamId != null) _engine?.sendStreamMessage(streamId, "mute user blet");
    _engine.switchCamera();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  _createChannel(String name) async {
    final prefs = GetStorage();

    var img = widget.image;
    _channel = await _client.createChannel(name);

    String channelId = widget.channelName;
    Echo("THIS IS CHANNEL ID ----------- $channelId");
    Echo("THIS IS User Info  ----------- name is ${widget.userName} + image is $img");
    if (channelId.isEmpty) {
      return;
    }
    _channel.join().then((value) {
      getChannelCount();
      _channel.onMemberJoined = (AgoraRtmMember member) {
        var img = widget.image;
        Echo("RTM Member Joined: ${member.userId} , Channel name ${member.channelId}");
        sendChannelMessage(info: 'Member joined: ', user: widget.userName, type: 'join');
        getChannelCount();

        if (userList.length > 0)
          setState(() {
            anyPerson = true;
            userList //TODO:: check this
                .add(BroadCastUser(username: member.userId, name: name, image: img));
          });
        userMap.putIfAbsent(member.userId, () => img);
        getChannelCount();
      };
      _channel.onMemberLeft = (AgoraRtmMember member) {
        Echo("RTM Member left: " + member.userId + ', channel:' + member.channelId);
        getChannelCount();
        userList.removeWhere((user) => user.username == member.userId);
        if (userList.length == 0)
          setState(() {
            anyPerson = false;
          });
        // sendChannelMessage(info: 'Member joined: ', user: member.userId, type: 'join');
      };
      _channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) async {
        Echo("RTM Received message on channel:${message.toString()}");

        sendChannelMessage(user: widget.userName, info: message.text, type: 'message');
      };
      _channel.onAttributesUpdated = (List<AgoraRtmChannelAttribute> attributes) {
        Echo("Channel attributes are updated");
      };
    });
  }

  void sendChannelMessage({String info, String type, String user}) {
    if (type == 'message' && info.contains('m1x2y3z4p5t6l7k8')) {
    } else if (type == 'message' && info.contains('k1r2i3s4t5i6e7')) {
      setState(() {
        accepted = true;
        personBool = false;

        waiting = false;
      });
    } else if (type == 'message' && info.contains('E1m2I3l4i5E6')) {
      setState(() {
        accepted = false;
      });
    } else if (type == 'message' && info.contains('R1e2j3e4c5t6i7o8n9e0d')) {
      setState(() {
        waiting = false;
      });
      /*FlutterToast.showToast(
          msg: "Guest Declined",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );*/

    } else {
      var image = userMap[user];
      Message m = new Message(message: info, type: type, user: user, image: image);
      Echo("THIS IS INFO ----------- $info");
      setState(() {
        messages.insert(0, m);
      });
    }
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel.sendMessage(AgoraRtmMessage.fromText('123'));
      sendChannelMessage(user: widget.userName, info: text, type: 'message');
    } catch (errorCode) {
      sendChannelMessage(info: 'Send channel message error: ' + errorCode.toString(), type: 'error');
    }
  }

  Future<void> getChannelCount() async {
    List<AgoraRtmMember> membersData = await _channel.getMembers();
    setState(() {
      if (membersData != null) {
        userNo = membersData.length;
        Echo("Channel Count:${membersData.length}");
      }
    });
  }

  Widget switchCamera() {
    if (currentUserRole == ClientRole.Broadcaster)
      return Row(
        children: [
          GestureDetector(
            onTap: _onSwitchCamera,
            child: Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                    AppColors().primaryLightColor(),
                    AppColors().primaryColor(),
                    AppColors().primaryDarkColor(),
                  ]),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Row(
                children: [
                  Icon(
                    Icons.switch_camera,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    return Container();
  }

  Widget muteMic() {
    if (currentUserRole == ClientRole.Broadcaster)
      return GestureDetector(
        onTap: _onToggleMute,
        child: Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                AppColors().primaryLightColor(),
                AppColors().primaryColor(),
                AppColors().primaryDarkColor(),
              ]),
              borderRadius: BorderRadius.all(Radius.circular(100))),
          child: Icon(
            muted ? Icons.mic_off : Icons.mic,
            color: muted ? Colors.red : Colors.white,
            size: 20.0,
          ),
        ),
      );
    return Container();
  }
}
