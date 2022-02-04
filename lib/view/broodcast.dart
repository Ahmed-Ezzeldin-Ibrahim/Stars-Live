import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constant/contant.dart';
import '../controller/profie_controller.dart';
import '../model/User.dart';
import '../model/broad_cast_user.dart';
import '../model/menu_item.dart';
import '../model/message.dart';
import '../repository/profile_response.dart';
import '../repository/user_repository.dart';
import '../video_live_v2/single_chat_view.dart';
import '../widget/top_users/supporters/all_supporters.dart';
import '../widget/top_users/supporters/shift_supporters.dart';
import '../widget/top_users/supporters/today_supporters.dart';
import 'resultScreen.dart';

class Broadcast extends StatefulWidget {
  final Profile profile;
  final ClientRole role;

  const Broadcast({
    Key key,
    @required this.role,
    @required this.profile,
  }) : super(key: key);

  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<Broadcast> {
  ClientRole userRole = ClientRole.Audience;
  final _users = <int>[];
  final List<BroadCastUser> userList = [];
  final List<Message> _infoString = [];
  final List<String> _infoStrings = [];
  RtcEngine _engine;
  bool muted = false;
  int streamId;
  String receivedCoins = '0';
  bool tryingToEnd = false;
  bool personBool = false;
  bool waiting = false;
  bool _isLogin = false;
  bool _isInChannel = false;
  bool accepted = false;
  bool anyPerson = false;
  int userNo = 0;
  var userMap;
  bool ontap = false;
  var profileController = ProfileController();
  var _channelMessageController = TextEditingController();
  bool showGifts = false;
  String sendGift = '';
  String sendGiftSenderName = '';
  String sendGiftReceiverName = '';
  double height;
  final TextEditingController textEditingController = TextEditingController();
  FocusNode chatFocusNode = FocusNode();

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=BBAyRBTfsOU"),
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
      disableDragSeek: true,
      enableCaption: false,
      controlsVisibleAtStart: false,
      hideControls: true,
      hideThumbnail: true,
      loop: false,
    ),
  );

  @override
  void dispose() {
    // clear users
    _users.clear();
    _client.destroy();
    _channel.leave();
    _engine.leaveChannel();
    // destroy sdk and leave channel
    _engine.destroy();
    deleteToken();

    super.dispose();
  }

  bool showui = false;
  @override
  void initState() {
    userRole = widget.role;
    showui = false;
    createToken(widget.profile.name).then((_) {
      print(agoraToken);
      initializeAgora().then((_) {
        _createClient().then((value) {
          setState(() {
            agoraToken = agoraToken;
            setLiveUser("1");
            userMap = {widget.profile.name: widget.profile.image};
            showui = true;
          });
        });
      });
    });
    startGiftsStream();
    super.initState();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      final info = 'onJoinChannel: $channel, uid: $uid';
      _infoStrings.add(info);
    }, leaveChannel: (stats) {
      _infoStrings.add('onLeaveChannel');
      _users.clear();
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      final info = 'userOffline: $uid';
      _infoStrings.add(info);
      _users.remove(uid);
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  User joinedUser;
  Future<void> initializeAgora() async {
    print("CHANNEL NAME IS ---------------- ${widget.profile.name}");
    print("CHANNEL TOKEN IS ---------------- $agoraToken");
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await _engine.joinChannel(agoraToken, '${widget.profile.id}', null, widget.profile.id);
    await _engine.joinChannel(null, 'ch${widget.profile.id}', null, widget.profile.id);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);

    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(160, 120);
    configuration.bitrate = 65;
    configuration.frameRate = VideoFrameRate.Fps15;

    await _engine.setVideoEncoderConfiguration(configuration);
  }

  Future _createClient() async {
    _client = await AgoraRtmClient.createInstance(chatId);
    final prefs = GetStorage();
    int userId = widget.profile.id;
    _client.login(null, userId.toString()).then((value) {
      print("User Logged IN ");
      setState(() {
        _isInChannel = true;
        _isLogin = true;
      });
    });
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log(user: peerId, info: message.text, type: 'message');
    };
    //testing
    _client.onConnectionStateChanged = (int state, int reason) {
      print("agora Connection State ${state.toString()}");
      if (state == 5) {
        _client.logout();
        //_log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    await _createChannel(widget.profile.name);
  }

  bool doneInit = false;

  @override
  Widget build(BuildContext context) {
    doneInit = true;

    height = MediaQuery.of(context).size.height;

    return WillPopScope(
      child: Scaffold(
        body: showui == false
            ? new Center(child: CircularProgressIndicator())
            : Center(
                child: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      _broadcastView(),

                      if (tryingToEnd == false)
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _userImage(),
                                // _guestsList(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _usersImage(),
                                    _liveText(),
                                  ],
                                ),
                              ],
                            ),
                            _showUserName(),
                            _userLevel(),
                          ],
                        ),

                      if (sendGift != null && sendGift.isNotEmpty)
                        Positioned(
                            left: 0,
                            right: 0,
                            top: 120,
                            child: TweenAnimationBuilder(
                              key: Key(sendGift),
                              duration: Duration(milliseconds: 7500),
                              tween: Tween<double>(begin: 0, end: 2),
                              builder: (context, value, child) {
                                if (value >= 2) {
                                  sendGift = '';
                                  return Container();
                                }
                                return Opacity(
                                  opacity: value > 1 ? 2 - value : value,
                                  child: Container(
                                    height: MediaQuery.of(context).size.width / 2,
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Text(
                                          'ارسل $sendGiftSenderName هدية الي $sendGiftReceiverName',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Expanded(
                                          child: CachedNetworkImage(
                                            imageUrl: sendGift,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )),

                      if (tryingToEnd == false)
                        Positioned(
                          bottom: 130,
                          left: 0,
                          right: 0,
                          top: /*chatFocusNode.hasFocus ?height / 1.5 :*/ height / 2,
                          child: Container(
                            height: height,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('stars')
                                        .doc(widget.profile.name)
                                        .collection('messages_v2_${DateTime.now().day}_${DateTime.now().month}')
                                        .orderBy('time', descending: true)
                                        .limit(20)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container();
                                      } else if (snapshot.data.docs.length < 1) {
                                        return Container();
                                      } else {
                                        return ListView.builder(
                                          padding: EdgeInsets.all(10.0),
                                          itemBuilder: (context, index) => SingleChatView(
                                              index: index,
                                              document: snapshot.data.docs[index],
                                              width: MediaQuery.of(context).size.width,
                                              role: ClientRole.Audience,
                                              channelId: widget.profile.name,
                                              usersLength: _users.length,
                                              imAdmin: '${widget.profile.id}' == '${widget.profile.id}' ? true : false,
                                              sendKickUsersToSteam: (String userId, String userName) {}),
                                          itemCount: snapshot.data.docs.length,
                                          reverse: true,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (tryingToEnd == false)
                        Positioned(
                          bottom: 75,
                          left: 0,
                          right: 0,
                          child: buildInput(),
                        ),
                      // if (tryingToEnd == false) _bottomBar(context),
                      // if (tryingToEnd == false) messageList(),
                      if (tryingToEnd == true) endLive(),
                      if (personBool == true && waiting == false) personList(),
                      if (accepted == true) stopSharing(),
                      if (waiting == true) guestWaiting(),

                      if (true)
                        ..._infoStrings.map((e) {
                          return Text(
                            'error $e',
                            style: TextStyle(
                              color: Colors.yellow,
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
      ),
      onWillPop: _willPopCallback,
    );
  }

  Widget buildInput() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                keyboardType: TextInputType.text,
                focusNode: chatFocusNode,
                style: TextStyle(color: Colors.black, fontSize: 10.0),
                textInputAction: TextInputAction.send,
                textDirection: TextDirection.rtl,
                onEditingComplete: () {
                  setState(() {
                    chatFocusNode.unfocus();
                    if (textEditingController.text != null && textEditingController.text.length > 0) {
                      sendChatMessage(textEditingController.text, null);
                      textEditingController.clear();
                    }
                  });
                },
                controller: textEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'اكتب رسالتك ...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                cursorColor: Colors.orange[900],
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(
                  Icons.send,
                  color: AppColors().primaryColor(),
                ),
                onPressed: () {
                  if (textEditingController.text != null && textEditingController.text.length > 0) {
                    sendChatMessage(textEditingController.text, null);
                    textEditingController.clear();
                  }
                },
                color: Colors.blue,
              ),
            ),
            color: Colors.white.withOpacity(0),
          ),
        ],
      ),
      width: double.infinity,
      height: 51.0,
      decoration: new BoxDecoration(color: Colors.white.withOpacity(0.9), border: new Border.all(color: AppColors().primaryColor(opacity: 0.6)), borderRadius: BorderRadius.all(Radius.circular(40))),
    );
  }

  void sendChatMessage(String message, String image, {bool entryImage = false, bool flyImage = false}) async {
    if (widget.profile != null && widget.profile.id != null && widget.profile.name != null) {
      String level = widget.profile != null
          ? widget.profile.levelUser != null
              ? '${widget.profile.levelUser.level}'
              : '1'
          : '1';
      if (level == null || level.isEmpty) level = '1';
      FirebaseFirestore.instance
          .collection('stars')
          .doc(widget.profile.name)
          .collection('messages_v2_${DateTime.now().day}_${DateTime.now().month}')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(
        {
          'id': '${widget.profile.id}',
          'name': widget.profile.name,
          'level': widget.profile != null
              ? widget.profile.levelUser != null
                  ? '${widget.profile.levelUser.level}'
                  : "1"
              : '1',
          'chat_image': null,
          'entry_image': null,
          'message': message,
          'fly_image': flyImage ? image : null,
          'time': '${DateTime.now().millisecondsSinceEpoch}',
        },
      );
    } else {}
  }

  Widget _usersImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
            gradient: LinearGradient(
              colors: <Color>[Colors.indigo, Colors.blue],
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Row(
            children: List.generate(
          (_users.length + 1),
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.black,
                  shape: BoxShape.circle,
                  image: DecorationImage(image: widget.profile.image == null ? AssetImage('assets/img/person.png') : NetworkImage(widget.profile.image), fit: BoxFit.contain)),
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

  Widget _liveText() {
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

  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Text("null"); // return type can't be null, a widget was required
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
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
            itemCount: _infoString.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoString.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: (_infoString[index].type == 'join')
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            /*CachedNetworkImage(
                              imageUrl: _infoString[index].image,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                            ),*/
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '${joinedUser.name} joined',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : (_infoString[index].type == 'message')
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10, right: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: joinedUser == null ? "" : joinedUser.image ?? "",
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
                                        _infoString[index].user,
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
                                        _infoString[index].message,
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

  Widget endLive() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Are you sure you want to end your live video?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'End Video',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      elevation: 2.0,
                      color: Colors.blue,
                      onPressed: () async {
                        setLiveUser("0");
                        _logout();
                        _leaveChannel();
                        _engine.leaveChannel();
                        _engine.destroy();

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultScreen()));
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 8.0, top: 8.0, bottom: 8.0),
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      elevation: 2.0,
                      color: Colors.grey,
                      onPressed: () {
                        setState(() {
                          tryingToEnd = false;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
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

  Widget _liveImg1() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.0),
                  gradient: LinearGradient(
                    colors: <Color>[Colors.indigo, Colors.blue],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    child: YoutubePlayer(
                      width: 200,
                      controller: _controller,
                      showVideoProgressIndicator: false,
                      onEnded: (_) {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
            gradient: LinearGradient(
              colors: <Color>[Colors.indigo, Colors.blue],
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.black,
              shape: BoxShape.circle,
              image: DecorationImage(image: widget.profile.image == null ? AssetImage('assets/img/person.png') : NetworkImage(widget.profile.image), fit: BoxFit.contain)),
        ),
      ),
    );
  }

  Widget _showUserName() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
            gradient: LinearGradient(
              colors: <Color>[Colors.indigo, Colors.blue],
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            children: [
              Text(
                widget.profile.name,
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.orange,
              gradient: LinearGradient(
                colors: <Color>[Colors.deepOrange.shade400, Colors.orangeAccent],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Text(
            widget.profile.levelUser == null ? "1" : "${widget.profile.levelUser.level}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
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
                    Text(
                      '${receivedCoins}',
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

  final _kTabPages = <Widget>[];

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

  SetList() {
    return ListTile(
      leading: Container(
        height: 80,
        width: 60,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(''))),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('العنوان'), Text('تم دعم المضيف ب كوينز')],
      ),
    );
  }

  Future<bool> _willPopCallback() async {
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

  void _logout() async {
    try {
      await _client.logout();
      //_log(info:'Logout success.',type: 'logout');
    } catch (errorCode) {
      //_log(info: 'Logout error: ' + errorCode.toString(), type: 'error');
    }
  }

  void _leaveChannel() async {
    try {
      await _channel.leave();
      //_log(info: 'Leave channel success.',type: 'leave');
      _client.releaseChannel(_channel.channelId);
      _channelMessageController.text = null;
    } catch (errorCode) {
      // _log(info: 'Leave channel error: ' + errorCode.toString(),type: 'error');
    }
  }

  List<Widget> getUserStories() {
    List<Widget> stories = [];
    for (BroadCastUser users in userList) {
      stories.add(getStory(users));
    }
    print("USER LIST IS ________________ $userList");
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
    if (userRole == ClientRole.Broadcaster) {
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
    if (streamId != null) _engine?.sendStreamMessage(streamId, "mute user blet");
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

    var img = widget.profile.image;
    _channel = await _client.createChannel(name);

    String channelId = widget.profile.name;
    print("THIS IS CHANNEL ID ----------- $channelId");
    print("THIS IS User Info  ----------- name is ${widget.profile.name} + image is $img");
    if (channelId.isEmpty) {
      return;
    }
    _channel.join().then((value) {
      getChannelCount();
      _channel.onMemberJoined = (AgoraRtmMember member) {
        var img = widget.profile.image;
        print("RTM Member Joined: ${member.userId} , Channel name ${member.channelId}");
        _log(info: 'Member joined: ', user: widget.profile.name, type: 'join');
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
        print("RTM Member left: " + member.userId + ', channel:' + member.channelId);
        getChannelCount();
        userList.removeWhere((user) => user.username == member.userId);
        if (userList.length == 0)
          setState(() {
            anyPerson = false;
          });
        // _log(info: 'Member joined: ', user: member.userId, type: 'join');
      };
      _channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) async {
        print("RTM Received message on channel:${message.toString()}");

        _log(user: joinedUser.name, info: message.text, type: 'message');
      };
      _channel.onAttributesUpdated = (List<AgoraRtmChannelAttribute> attributes) {
        print("Channel attributes are updated");
      };
    });
  }

  void _log({String info, String type, String user}) {
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
      print("THIS IS INFO ----------- $info");
      setState(() {
        _infoString.insert(0, m);
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
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(user: widget.profile.name, info: text, type: 'message');
    } catch (errorCode) {
      _log(info: 'Send channel message error: ' + errorCode.toString(), type: 'error');
    }
  }

  void _sendMessage(text) async {
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(user: widget.profile.name, info: text, type: 'message');
      //  _log(user: widget.profile.name, info:text,type: 'message');
    } catch (errorCode) {
      // _log('Send channel message error: ' + errorCode.toString());
    }
  }

  Future<void> getChannelCount() async {
    var membersData = await _channel.getMembers();
    setState(() {
      if (membersData != null) {
        userNo = membersData.length;
        print("Channel Count:${membersData.length}");
      }
    });
  }

  Widget switchCamera() {
    if (userRole == ClientRole.Broadcaster)
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
    if (userRole == ClientRole.Broadcaster)
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

  startGiftsStream() async {
    receivedCoins = await getUserByIdDiamonds(context, userId: '${widget.profile.id}');
    FirebaseFirestore.instance.collection('stars').doc(widget.profile.name).collection('gifts').limit(1).snapshots().listen((snapShot) async {
      if (snapShot.docs.length > 0) {
        receivedCoins = await getUserByIdDiamonds(context, userId: '${widget.profile.id}');
        if (doneInit) {
          if (snapShot.docs[0].data().containsKey('image') && '${snapShot.docs[0].get('image')}'.isNotEmpty) {
            setState(() {
              sendGift = snapShot.docs[0].get('image');
              sendGiftSenderName = !snapShot.docs[0].data().containsKey('sender') ? '' : snapShot.docs[0].get('sender');
              sendGiftReceiverName = !snapShot.docs[0].data().containsKey('receiver') ? '' : snapShot.docs[0].get('receiver');
            });
          }
        }
      }
      if (snapShot.docs.length > 0) FirebaseFirestore.instance.collection('stars').doc(widget.profile.name).collection('gifts').doc(snapShot.docs[0].id).delete();
    });
  }
}
