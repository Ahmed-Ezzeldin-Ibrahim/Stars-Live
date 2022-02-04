import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constant/contant.dart';
import '../model/User.dart';
import '../model/message.dart';
import '../repository/user_repository.dart';

class BroadcastPage extends StatefulWidget {
  final String channelName;
  final String image;
  final time;

  const BroadcastPage({Key key, this.channelName, this.image, this.time, bool isBroadcaster}) : super(key: key);

  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final List<int> _users = [];
  List<User> userList = [];
  final List<String> _infoStrings = [];
  final List<Message> _infoMessage = [];
  RtcEngine _engine;
  bool muted = false;
  int streamId;
  bool _isLogin = true;
  bool _isInChannel = true;
  int userNo = 0;
  var userMap;
  Timer _timer;
  var tryingToEnd = false;
  bool personBool = false;
  bool accepted = false;
  bool heart = false;
  bool anyPerson = false;
  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  //Love animation
  final _random = math.Random();
  double height = 0.0;
  int guestID = -1;
  bool waiting = false;
  var _channelMessageController = TextEditingController();
  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk and leave channel
    _engine.destroy();
    _engine.leaveChannel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initializeAgora();
    _createClient();
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(appId);
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {};
    _client.onConnectionStateChanged = (int state, int reason) {
      if (state == 5) {
        _client.logout();
        //_log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    await _client.login(agoraToken, widget.channelName);
    _channel = await _createChannel(widget.channelName);
    await _channel.join();
  }

  String baseUrl = baseLinkApi; //Add the link to your deployed server here
  int uid = 0;
  String token;

  Future<void> getToken() async {
    final response = await http.get(
      Uri.parse(baseUrl + '/rtc/' + widget.channelName + '/publisher/uid/' + uid.toString()
          // To add expiry time uncomment the below given line with the time in seconds
          // + '?expiry=45'
          ),
    );

    if (response.statusCode == 200) {
      setState(() {
        token = response.body;
        token = jsonDecode(token)['rtcToken'];
      });
    } else {
      print('Failed to fetch the token');
    }
  }

  Future<void> initializeAgora() async {
    await _initAgoraRtcEngine();
    final prefs = GetStorage();
    currentUser.value.name = prefs.read('current_user_name');

    streamId = await _engine?.createDataStream(false, false);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    _addAgoraEventHandlers(user: currentUser.value.name);
    await _engine.joinChannel(agoraToken, widget.channelName, null, 0);
  }

  void _addAgoraEventHandlers({String user}) {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        print(info);
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'has joined: $channel, uid: $user';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $user';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $user';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $user ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();

    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);

    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));

    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: ClipRRect(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();

    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
    }
    return Container();

    /*    return Container(
        child: Column(
          children: <Widget>[_videoView(views[0])],
        ));*/
  }

  void popUp() async {
    setState(() {
      heart = true;
    });

    _timer = Timer.periodic(Duration(milliseconds: 125), (Timer t) {
      setState(() {
        height += _random.nextInt(20);
      });
    });

    Timer(
        Duration(seconds: 4),
        () => {
              _timer.cancel(),
              setState(() {
                heart = false;
              })
            });
  }

  /// Info panel to show logs
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
            itemCount: _infoMessage.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoMessage.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: (_infoMessage[index].type == 'join')
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: _infoMessage[index].image,
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
                                '${_infoMessage[index].user} joined',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : (_infoMessage[index].type == 'message')
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: _infoMessage[index].image,
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
                                        _infoMessage[index].user,
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
                                        _infoMessage[index].message,
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

  void _onSwitchCamera() {
    _engine.switchCamera();
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

  Widget _endCall() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
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
              child: Text(
                'END',
                style: TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _liveText() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.orange, Colors.blue],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                child: Text(
                  'LIVE',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
                          CupertinoIcons.eye,
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
                        await _logout();
                        await _leaveChannel();
                        await _engine.leaveChannel();
                        await _engine.destroy();
                        //FireStoreClass.deleteUser(username: channelName);
                        Navigator.pop(context);
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

  List<Widget> getUserStories() {
    List<Widget> stories = [];
    for (User users in userList) {
      stories.add(getStory(users));
    }
    return stories;
  }

  Widget getStory(User users) {
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

  Widget stopSharing() {
    return Container(
      height: MediaQuery.of(context).size.height / 2 + 40,
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: MaterialButton(
          minWidth: 0,
          onPressed: () async {
            stopFunction();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            body: Container(
              color: Colors.black,
              child: Center(
                child: Stack(
                  children: <Widget>[
                    _viewRows(), // Video Widget
                    if (tryingToEnd == false) _endCall(),
                    if (tryingToEnd == false) _liveText(),
                    // if(heart == true && tryingToEnd==false) heartPop(),
                    if (tryingToEnd == false) _bottomBar(), // send message
                    if (tryingToEnd == false) messageList(),
                    if (tryingToEnd == true) endLive(), // view message
                    if (personBool == true && waiting == false) personList(),
                    if (accepted == true) stopSharing(),
                    if (waiting == true) guestWaiting(),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _willPopCallback);
  }
// Agora RTM

  Widget _bottomBar() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            new Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
              child: new TextField(
                  cursorColor: Colors.blue,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    _sendMessage(value);
                  },
                  style: TextStyle(color: Colors.white),
                  controller: _channelMessageController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Comment',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: BorderSide(color: Colors.white)),
                  )),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
              child: MaterialButton(
                minWidth: 0,
                onPressed: _toggleSendChannelMessage,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                color: Colors.blue[400],
                padding: const EdgeInsets.all(12.0),
              ),
            ),
            if (accepted == false)
              Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                child: MaterialButton(
                  minWidth: 0,
                  onPressed: _addPerson,
                  child: Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  color: Colors.blue[400],
                  padding: const EdgeInsets.all(12.0),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
              child: MaterialButton(
                minWidth: 0,
                onPressed: _onSwitchCamera,
                child: Icon(
                  Icons.switch_camera,
                  color: Colors.blue[400],
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                color: Colors.white,
                padding: const EdgeInsets.all(12.0),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void _addPerson() {
    setState(() {
      personBool = !personBool;
    });
  }

  void stopFunction() {
    setState(() {
      accepted = false;
    });
  }

  Future<void> _logout() async {
    try {
      await _client.logout();
      //_log(info:'Logout success.',type: 'logout');
    } catch (errorCode) {
      //_log(info: 'Logout error: ' + errorCode.toString(), type: 'error');
    }
  }

  Future<void> _leaveChannel() async {
    try {
      await _channel.leave();
      //_log(info: 'Leave channel success.',type: 'leave');
      _client.releaseChannel(_channel.channelId);
      _channelMessageController.text = null;
    } catch (errorCode) {
      // _log(info: 'Leave channel error: ' + errorCode.toString(),type: 'error');
    }
  }

  Future<void> _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    print('My Message is $text');
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
    } catch (errorCode) {
      //_log(info: 'Send channel message error: ' + errorCode.toString(), type: 'error');
    }
  }

  Future<void> _sendMessage(text) async {
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
    } catch (errorCode) {
      // _log('Send channel message error: ' + errorCode.toString());
    }
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client.createChannel(name);
    channel.onMemberJoined = (AgoraRtmMember member) async {
      print("member is ${member.userId}");
      var img = currentUser.value.image;
      var nm = currentUser.value.name;
      setState(() {
        userList.add(new User(id: int.parse(member.userId), name: nm, image: img));
        if (userList.length > 0) anyPerson = true;
      });
      userMap.putIfAbsent(member.userId, () => img);
      var len;
      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len + 1;
        });
      });
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      var len;
      setState(() {
        userList.removeWhere((element) => element.id == member.userId);
        if (userList.length == 0) anyPerson = false;
      });

      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len - 1;
        });
      });
    };
    channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
      _infoStrings.add(message.text);
    };
    return channel;
  }
}
