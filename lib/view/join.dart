import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart'; 
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../helper/echo.dart';
import '../model/gifts.dart';
import '../repository/gifts_repository.dart';
import '../repository/user_repository.dart';

import '../constant/contant.dart';
import '../model/User.dart';
import '../model/live_user.dart';
import '../model/menu_item.dart';
import '../model/message.dart';
import '../provider/gifts_provider.dart';
import '../repository/profile_response.dart';
import '../video_live_v2/single_chat_view.dart';
import 'diamond.dart';

class JoinPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final LiveUserData liveUser;
  final Profile profile;
  final String token;

  /// Creates a call page with given channel name.
  const JoinPage({
    this.liveUser,
    this.profile,
    this.token,
  });

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<Offset> offset;
  Gifts gifts;
  bool giftsLoading = false;
  final _users = <int>[];
  final List<int> userList = [];
  final List<Message> _infoString = [];
  final List<String> _infoStrings = [];
  RtcEngine _engine;

  int streamId;

  bool waiting = false;

  bool accepted = false;

  bool anyPerson = false;
  int userNo = 0;
  var userMap;
  bool loading = true;
  bool completed = false;
  bool muted = true;

  bool heart = false;
  bool requested = false;

  bool _isLogin = true;
  bool _isInChannel = true;

  var _channelMessageController = TextEditingController();
  double height;
  final TextEditingController textEditingController = TextEditingController();
  FocusNode chatFocusNode = FocusNode();

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;

  bool showGifts = false;
  int sendGiftTime = 0;
  String receivedCoins = '0';
  String sendGift = '';
  String sendGiftSenderName = '';
  String sendGiftReceiverName = '';

  @override
  void dispose() {
    // clear users
    _users.clear();
    _client.destroy();
    _channel.leave();
    _engine.leaveChannel();
    // destroy sdk and leave channel
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 4));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(-5, -1.0)).animate(animationController);
    super.initState();
    _createClient();
    initializeAgora();
    startGiftsStream();

    setState(() {
      selectedItem = false;
    });
  }

  final List<User> usersList = [];

  bool selectedItem = false;
  bool doneInit = false;
  int giftId;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> initializeAgora() async {
    await _initAgoraRtcEngine();
    // await _engine.joinChannel(widget.channelToken, widget.liveUser.name, null, widget.profile.id);
    print("CHANNEL NAME IS ---------------- ${widget.profile.name}");
    print("CHANNEL TOKEN IS ---------------- $agoraToken");
    _addAgoraEventHandlers();
    await _engine.joinChannel(null, 'ch${widget.liveUser.id}', null, widget.profile.id);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        var info = "onJoinChannel: $channel, uid: $uid";
        _infoStrings.add(info);
      },
      leaveChannel: (stats) {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      },
      userJoined: (uid, elapsed) async {
        await getChannelCount();
        setState(() {
          var info = "userJoined: $uid";
          _infoStrings.add(info);
          _users.add(uid);
          usersList.add(User(id: widget.profile.id, image: widget.profile.image));
        });
      },
      userOffline: (uid, elapsed) {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _infoStrings.add(info);
        });
      },
      tokenPrivilegeWillExpire: (token) async {
        await _engine.renewToken(token);
      },
    ));
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.enableVideo();
    await _engine.enableAudio();
    await _engine.setClientRole(ClientRole.Audience);
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(chatId);
    final prefs = GetStorage();
    print("USER ID ");
    print(widget.profile.id);
    _client.login(null, widget.profile.id.toString()).then((value) {
      setState(() {
        _isInChannel = true;
        _isLogin = true;
      });
    });
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log(user: peerId, info: message.text, type: 'message');
    };

    _client.onConnectionStateChanged = (int state, int reason) {
      print("agora error ${state.toString()}");
      if (state == 5) {
        _client.logout();
        //_log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    await _createChannel(widget.liveUser.name);
    //_channel = await _createChannel(appId);
    // await _channel.join();
  }

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    doneInit = true;
    height = MediaQuery.of(context).size.height;

    return WillPopScope(
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: SafeArea(
            child: Center(
              child: (completed == true)
                  ? _ending()
                  : Stack(
                      children: <Widget>[
                        _broadcastView(),

                        //_panel(),
                        // if (completed == false) _bottomBar(context),
                        _liveText(),
                        if (completed == false) _userImage(),
                        if (completed == false) _usersImage(),
                        if (completed == false) _showUserName(),
                        //if (completed == false) _showFollowIcon(),

                        if (completed == false) _userLevel(),
                        if (sendGift != null && sendGift.isNotEmpty)
                          Positioned(
                              left: 0,
                              right: 0,
                              top: 12,
                              bottom: 12,
                              child: TweenAnimationBuilder(
                                key: Key(sendGift + '$sendGiftTime'),
                                duration: Duration(milliseconds: 7500),
                                tween: Tween<double>(begin: 0, end: 2),
                                builder: (context, value, child) {
                                  if (value >= 2) {
                                    sendGift = '';
                                    sendGiftTime++;
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

                        if (completed == false)
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
                                          .doc(widget.liveUser.name)
                                          .collection('messages_v2_${DateTime.now().day}_${DateTime.now().month}')
                                          .orderBy('time', descending: true)
                                          .limit(20)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        } else if (snapshot.hasError) {
                                          if (kDebugMode)
                                            return Text(
                                              '${snapshot.error}',
                                              style: TextStyle(color: Colors.red),
                                            );
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
                                                channelId: widget.liveUser.name,
                                                usersLength: _users.length,
                                                imAdmin: '${widget.profile.id}' == '${widget.liveUser.id}' ? true : false,
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

                        if (completed == false)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: buildInput(),
                          ),
                        if (requested == true) requestedWidget(),
                        if (accepted == true) stopSharing(),
                        // if (completed == false) ContainerGift(),
                        if (true && kDebugMode) _panel()
                        // Column(
                        //   children: [
                        //     ..._infoStrings.map((e) {
                        //       return Column(
                        //         children: [
                        //           Text(
                        //             'error $e',
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //         ],
                        //       );
                        //     }),
                        //   ],
                        // )
                      ],
                    ),
            ),
          ),
        ),
      ),
      onWillPop: _willPopCallback,
    );
  }

  Widget buildInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
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
            decoration:
                new BoxDecoration(color: Colors.white.withOpacity(0.9), border: new Border.all(color: AppColors().primaryColor(opacity: 0.6)), borderRadius: BorderRadius.all(Radius.circular(40))),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: giftsLoading
              ? Container(width: 36, height: 36, child: CircularProgressIndicator())
              : GestureDetector(
                  onTap: () async {
                    if (gifts == null) {
                      giftsLoading = true;
                      setState(() {});
                      gifts = await getGifts();

                      giftsLoading = false;
                      setState(() {});
                    }
                    Echo('gifts = ');
                    Echo('gifts = ${gifts.data.length}');
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        int _selectedIndex = -1;
                        return Container(
                          child: StatefulBuilder(
                            builder: (context, setState2) {
                              return Container(
                                  height: MediaQuery.of(context).size.height / 2,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: gifts == null
                                            ? Center(child: CircularProgressIndicator())
                                            : GridView.builder(
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 6,
                                                  crossAxisSpacing: 12,
                                                  childAspectRatio: 0.5,
                                                ),
                                                scrollDirection: Axis.vertical,
                                                itemCount: gifts.data.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _selectedIndex = index;
                                                        setState2(() {});
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Expanded(
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  width: double.infinity,
                                                                  height: double.infinity,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    child: Image.network(
                                                                      gifts.data[index].image ?? 'https://picsum.photos/200',
                                                                      fit: BoxFit.fitWidth,
                                                                    ),
                                                                  ),
                                                                ),
                                                                _selectedIndex != null && _selectedIndex == index
                                                                    ? Positioned(
                                                                        right: 4,
                                                                        top: 4,
                                                                        child: Align(
                                                                          child: Icon(Icons.check_circle, color: Colors.green, size: 20),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(width: double.infinity, child: Text(gifts.data[index].name, textAlign: TextAlign.center)),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Expanded(child: Text("${gifts.data[index].valueInCoins}")),
                                                              Icon(Icons.monetization_on, color: Colors.yellow, size: 12),
                                                            ],
                                                          ),
                                                          SizedBox(height: 6),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 12),
                                          FlatButton(
                                              child: Text(
                                                "ارسال",
                                                style: TextStyle(
                                                  color: _selectedIndex < 0 ? Colors.grey : Colors.orange,
                                                  fontSize: 18,
                                                  fontWeight: _selectedIndex < 0 ? FontWeight.normal : FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                if (!kDebugMode && gifts.data[_selectedIndex].valueInCoins > widget.profile.balanceInCoins) {
                                                  Fluttertoast.showToast(msg: 'رصيد عملاتك غير كافي');
                                                  return;
                                                }
                                                if (_selectedIndex < 0) return;
                                                if (gifts.data[_selectedIndex].valueInCoins > 0) {
                                                  sendGiftFunc(
                                                    '${widget.liveUser.id}',
                                                    gifts.data[_selectedIndex].valueInCoins,
                                                    gifts.data[_selectedIndex].image,
                                                  );
                                                }
                                                GiftsProvider().sendUserGifts(
                                                  giftId: gifts.data[_selectedIndex].id.toString(),
                                                  receiverId: widget.liveUser.id.toString(),
                                                );
                                                widget.profile.balanceInCoins = widget.profile.balanceInCoins - gifts.data[_selectedIndex].valueInCoins;
                                                Navigator.pop(context);
                                              }),
                                          Expanded(child: SizedBox(width: 2)),
                                          Text("${widget.profile.balanceInCoins}"),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiamondWidget()));
                                            },
                                            child: Icon(Icons.monetization_on, color: Colors.yellow, size: 16),
                                          ),
                                          SizedBox(width: 12),
                                        ],
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        'assets/img/gifts.jpg',
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
        ),
      ],
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
          .doc(widget.liveUser.name)
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
          'chat_image': image,
          'entry_image': null,
          'message': '$message',
          'fly_image': flyImage ? image : null,
          'time': '${DateTime.now().millisecondsSinceEpoch}',
        },
      );
    } else {}
  }

  Widget _usersImage() {
    return Positioned(
      right: 150,
      child: Padding(
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
            usersList.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(usersList[index].image),
                    )),
              ),
            ),
          ).toList()),
        ),
      ),
    );
  }

  Widget ContainerGift() {
    return Align(
      alignment: Alignment.topCenter,
      child: SlideTransition(
          position: offset,
          child: Padding(
              padding: EdgeInsets.only(top: 40, right: 20, left: 20),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.6), width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('لقد ارسل فلان هدية اسما'),
                    ],
                  ),
                ),
              ))),
    );
  }

  Widget _userImage() {
    return Positioned(
      right: 10,
      child: Padding(
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
                image: DecorationImage(image: widget.profile.image == null ? AssetImage('assets/img/person.png') : NetworkImage(widget.liveUser.image), fit: BoxFit.contain)),
          ),
        ),
      ),
    );
  }

  Widget _showUserName() {
    return Positioned(
      right: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.0),
              gradient: LinearGradient(
                colors: <Color>[Colors.indigo, Colors.blue],
              ),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: Row(
              children: [
                Text(
                  widget.liveUser.name,
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
    );
  }

  Widget _showFollowIcon() {
    return Positioned(
      right: 130,
      top: 10,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.greenAccent.shade400,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            EvaIcons.plusSquareOutline,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _userLevel() {
    return Positioned(
      top: 50,
      right: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                "${widget.liveUser.levelHost.level}",
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
                decoration: BoxDecoration(color: Colors.black.withOpacity(.6), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Row(
                  children: [
                    Text(
                      '${widget.profile.balanceInCoins}',
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
          ],
        ),
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
            await _channel.sendMessage(AgoraRtmMessage.fromText('E1m2I3l4i5E6 stoping'));
            await _engine.disableAudio();
            await _engine.disableVideo();
            setState(() {
              accepted = false;
            });
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

  Widget _ending() {
    return Container(
      color: Colors.black.withOpacity(.7),
      child: Center(
          child: Container(
        width: double.infinity,
        color: Colors.grey[700],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'The Live has ended',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
        ),
      )),
    );
  }

  Widget requestedWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          spacing: 0,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              width: 130,
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 130,
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      alignment: Alignment(0, 0),
                      children: <Widget>[
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        /*CachedNetworkImage(
                          imageUrl: widget.userImage,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  Container(
                    width: 130,
                    alignment: Alignment.centerRight,
                    child: Stack(
                      alignment: Alignment(0, 0),
                      children: <Widget>[
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        /* CachedNetworkImage(
                          imageUrl: widget.userImage,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '${widget.liveUser.name} Wants You To Be In This Live Video.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 0,
                bottom: 20,
                right: 20,
              ),
              child: Text(
                'Anyone can watch, and some of your followers may get notified.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[300],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Go Live with ${widget.liveUser.name}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                elevation: 2.0,
                color: Colors.blue[400],
                onPressed: () async {
                  await _engine.enableLocalVideo(true);
                  await _engine.enableLocalAudio(true);
                  await _channel.sendMessage(AgoraRtmMessage.fromText('k1r2i3s4t5i6e7 confirming'));
                  setState(() {
                    accepted = true;
                    requested = false;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Decline',
                    style: TextStyle(color: Colors.pink[300]),
                  ),
                ),
                elevation: 2.0,
                color: Colors.transparent,
                onPressed: () async {
                  await _channel.sendMessage(AgoraRtmMessage.fromText('R1e2j3e4c5t6i7o8n9e0d Rejected'));
                  setState(() {
                    requested = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _liveText() {
    return Positioned(
      right: 60,
      top: 30,
      child: Container(
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
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextField(
                    controller: _channelMessageController,
                    decoration: InputDecoration(
                      hintText: 'Say something ',
                      hintStyle: TextStyle(color: Colors.black),
                      suffix: Icon(
                        Icons.tag_faces_outlined,
                        color: Colors.white,
                      ),
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
            ),
            GestureDetector(
              onTap: () {
                int _selectedIndex = 0;

                _onSelected(int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }

                showBottomSheet(
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Container(
                        height: 200,
                        child: Consumer<GiftsProvider>(builder: (context, gifts, child) {
                          return Column(
                            children: [
                              Expanded(
                                child: gifts.gifts == null
                                    ? Center(child: CircularProgressIndicator())
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: gifts.gifts.data.length,
                                        semanticChildCount: 6,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: InkWell(
                                              onTap: () {
                                                _onSelected(index);
                                                print(_selectedIndex);
                                                if (gifts.gifts.data[_selectedIndex].valueInCoins >= 10) {
                                                  switch (animationController.status) {
                                                    case AnimationStatus.completed:
                                                      animationController.reverse();
                                                      break;
                                                    case AnimationStatus.dismissed:
                                                      animationController.forward();
                                                      break;
                                                    default:
                                                  }
                                                }
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      /*_selectedIndex != null &&
                                                      _selectedIndex == index*/

                                                      Container(
                                                        width: 50,
                                                        height: 50,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(20),
                                                          child: Image.network(
                                                            gifts.gifts.data[index].image ?? 'https://picsum.photos/200',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      _selectedIndex != null && _selectedIndex == index
                                                          ? Positioned(
                                                              right: 15,
                                                              top: 10,
                                                              child: Align(
                                                                child: Icon(
                                                                  Icons.check_circle_outline,
                                                                  color: Colors.green,
                                                                  size: 18,
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(gifts.gifts.data[index].name),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("${gifts.gifts.data[index].valueInCoins}"),
                                                      Icon(
                                                        Icons.monetization_on,
                                                        color: Colors.yellow,
                                                        size: 16,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                              ),
                              Row(
                                children: [
                                  FlatButton(
                                      child: Text(
                                        "ارسال",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        print("GIFT X1");
                                        //print(gifts.gifts.data[index].id);

                                        gifts.sendUserGifts(receiverId: widget.liveUser.name.toString(), giftId: gifts.gifts.data[_selectedIndex].id.toString()); //this is gift send function
                                        print("Sent Gift ${gifts.gifts.data[_selectedIndex].id}");
                                      }),
                                  Spacer(),
                                  Text("${widget.profile.balanceInCoins}"),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiamondWidget()));
                                    },
                                    child: Icon(
                                      Icons.monetization_on,
                                      color: Colors.yellow,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                      ),
                    );
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: 40,
                  height: 40,
                  child: Image.asset('assets/img/gift.jpeg', fit: BoxFit.cover),
                ),
              ),
            ),
            Row(
              children: [
                PopupMenuButton<MenuItem>(
                  offset: Offset.fromDirection(5),
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) {
                    return [
                      ...MenuItems.items.map(buildItem).toList(),
                      PopupMenuDivider(),
                    ];
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void onSelected(context, MenuItem item) {
    switch (item) {
      case MenuItems.share:
        //TODO: add share functionality
        break;
    }
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
                            CachedNetworkImage(
                              imageUrl: _infoString[index].image,
                              imageBuilder: (context, imageProvider) => Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '${_infoString[index].user} joined',
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
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: _infoString[index].image,
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

  Future<bool> _willPopCallback() async {
    _leaveChannel();
    _logout();
    _engine.leaveChannel();
    _engine.destroy();
    return true;
    // ret
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

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];

    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  Widget _videoView(view) {
    return Expanded(child: ClipRRect(child: view));
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
    if (views.length > 0)
      return Column(
        children: [
          Expanded(
            child: views[0],
          ),
        ],
      );

    return Container(color: Colors.black, child: Center(child: Text('NOT FOUND')));
  }

  _createChannel(String name) async {
    final prefs = GetStorage();
    var image = prefs.read("current_user_image");
    _channel = await _client.createChannel(name);
    String channelId = widget.liveUser.name;
    print("THIS IS CHANNEL ID ----------- $channelId");
    print("THIS IS User Info  ----------- name is ${widget.profile.name} + image is $image");
    if (channelId.isEmpty) {
      _log(info: 'Please input channel id to join.');
      return;
    }
    _channel.join().then((value) {
      getChannelCount();
      _channel.onMemberJoined = (AgoraRtmMember member) {
        print("RTM Member Joined: ${member.userId} , Channel name ${member.channelId}");

        if (member != null && member.userId != null) userMap.putIfAbsent(member.userId, () => image);
        _log(info: 'Member joined: ', user: member.userId, type: 'join');
      };
      _channel.onMemberLeft = (AgoraRtmMember member) {
        print("RTM Member left: " + member.userId + ', channel:' + member.channelId);
        getChannelCount();
      };
      _channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
        userMap.putIfAbsent(member.userId, () => image);
        print("RTM Received message on channel:${message.toString()}");
        _log(info: message.text, type: 'message', user: member.userId);
      };
      _channel.onAttributesUpdated = (List<AgoraRtmChannelAttribute> attributes) {
        print("Channel attributes are updated");
      };
    });
  }

  void _log({String info, String type, String user}) {
    if (type == 'message' && info.contains('m1x2y3z4p5t6l7k8')) {
    } else if (type == 'message' && info.contains('E1m2I3l4i5E6')) {
      setState(() {
        accepted = false;
      });
    } else {
      Message m;
      var image = widget.profile.image;
      if (info.contains('d1a2v3i4s5h6')) {
        var mess = info.split(' ');
        if (mess[1] == widget.profile.name) {
          /*m = new Message(
              message: 'working', type: type, user: user, image: image);*/
          setState(() {
            //_infoStrings.insert(0, m);
            requested = true;
          });
        }
      } else {
        m = new Message(message: info, type: type, user: user, image: image);
        setState(() {
          _infoString.insert(0, m);
        });
      }
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
      //  _log(user: widget.liveUser.name, info:text,type: 'message');
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

  startGiftsStream() async {
    receivedCoins = await getUserByIdDiamonds(context, userId: '${widget.profile.id}');
    FirebaseFirestore.instance.collection('stars').doc(widget.liveUser.name).collection('gifts').limit(1).snapshots().listen((snapShot) async {
      if (snapShot.docs.length > 0) {
        if (doneInit) {
          receivedCoins = await getUserByIdDiamonds(context, userId: '${widget.profile.id}');
          setState(() {
            sendGift = snapShot.docs[0].get('image');
            sendGiftTime++;
            sendGiftSenderName = !snapShot.docs[0].data().containsKey('sender') ? '' : snapShot.docs[0].get('sender');
            sendGiftReceiverName = !snapShot.docs[0].data().containsKey('receiver') ? '' : snapShot.docs[0].get('receiver');
          });
        }
      }

      if (snapShot.docs.length > 0) FirebaseFirestore.instance.collection('stars').doc(widget.liveUser.name).collection('gifts').doc(snapShot.docs[0].id).delete();
    });
  }

  void showGiftAnimation(String image, String stickerId, {bool sendToRoom = true, @required String id, int coins}) {
    if (coins < 80) {
      FirebaseFirestore.instance.collection('stars').doc(widget.liveUser.name).collection('gifts').doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
        {
          'coin': coins,
          'image': '',
          'sender': widget.profile.name,
          'receiver': widget.liveUser.name,
        },
      );
    } else {
      FirebaseFirestore.instance.collection('stars').doc(widget.liveUser.name).collection('gifts').doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
        {
          'coin': coins,
          'image': image,
          'sender': widget.profile.name,
          'receiver': widget.liveUser.name,
        },
      );
      if (doneInit)
        setState(() {
          sendGift = image;
          sendGiftSenderName = widget.profile.name;
          sendGiftReceiverName = widget.liveUser.name;
        });
    }
  }

  void sendGiftFunc(String id, int coins, String image) {
    if (widget.profile != null && widget.profile.balanceInCoins != null && coins != null) {
      showGiftAnimation(image, id, id: widget.liveUser.name, coins: coins);
      sendChatMessage(' ارسل هدية الي ${widget.liveUser.name}', image);
    } else if (coins == null) {
      showGiftAnimation(image, '0', id: '0', coins: null);
    }

    showGifts = false;
    setState(() {});
  }
}
