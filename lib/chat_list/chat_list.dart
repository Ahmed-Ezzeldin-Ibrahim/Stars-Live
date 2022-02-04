import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../chat/chat_controller.dart';
import '../helper/app_config.dart';
import '../helper/echo.dart';
import '../main_provider_model.dart';

class ContactsScreen extends StatelessWidget {
  static const String id = 'contactsScreen';

  @override
  Widget build(BuildContext context) {
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);

    return Container(
      color: AppColors().primaryDarkColor(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('المحادثات'),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('stars-users')
                .doc('${mainProviderModel.profileData.id}')
                .collection('my-contacts')
                .orderBy('updated_at', descending: true)
//            .where('updated_at', isGreaterThan: '0')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('لا يوجد محادثات سابقة'));
              } else if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Center(child: Text("لا يوجد محادثات سابقة")),
                );
              } else {
                return ChatListStateful(snapshot.data.docs);
              }
            },
          ),
        ),
      ),
    );
  }
}

class ChatListStateful extends StatefulWidget {
  final docs;

  ChatListStateful(this.docs);

  @override
  _ChatListStatefulState createState() => _ChatListStatefulState();
}

class _ChatListStatefulState extends State<ChatListStateful> {
  Map usersStatusList = {
    0: false,
  };
  bool updateOnlineStatus = true;

  @override
  void initState() {
    super.initState();
    checkUserOnline();
  }

  @override
  Widget build(BuildContext context) {
    Echo('widget.docs.length ${widget.docs.length}');
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemBuilder: (context, index) => buildItem(
        context,
        widget.docs[index],
        index,
      ),
      itemCount: widget.docs.length,
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document, int index) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 4,
        color: Colors.deepPurpleAccent,
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Material(
                    child: document['userPhotoUrl'] != null
                        ? CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: Icon(
                                Icons.account_circle,
                                size: 65.0,
                                color: Colors.grey[100],
                              ),
                              width: 65.0,
                              height: 65.0,
                              padding: EdgeInsets.all(15.0),
                            ),
                            imageUrl: document['userPhotoUrl'],
                            width: 65.0,
                            height: 65.0,
                            errorWidget: (context, asd, error) {
                              return Icon(
                                Icons.account_circle,
                                color: Colors.blueGrey,
                                size: 65.0,
                              );
                            },
                          )
                        : Icon(
                            Icons.account_circle,
                            size: 65.0,
                            color: Colors.grey[100],
                          ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  if (updateOnlineStatus == true || updateOnlineStatus == false) widgetOnlineStatus(document['user_id'], document),
                  /* if (usersStatusList[index] != null)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: usersStatusList[index]
                                ? Colors.green
                                : Colors.grey,
                            border: Border.all(width: 2.0, color: Colors.white),
                          ),
                        ),
                      )*/
                ],
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${document['userName']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          '${document['last_message'] ?? 'Start chat!'}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
              if (document['unread_count'] != null && document['unread_count'] != 0)
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.green),
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      '${document['unread_count']}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatController(
                          documentId: document.id,
                          userId: document['user_id'],
                          userImage: document['userPhotoUrl'],
                          chatId: document['chat_id'],
                          chatWith: document['userName'],
                        )));
          },
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }

  checkUserOnline() async {
    return false;
    Echo('checkUserOnline');
    await widget.docs.asMap().forEach((index, value) {
      FirebaseFirestore.instance.collection('stars-users').doc(value['user_id']).snapshots().listen((snapshot) {
        if (snapshot != null && snapshot.data != null) {
          if (snapshot.data().containsKey('online') && snapshot.get('online') == null) {
            updateUsersStatusList(snapshot.data()['id'], false);
          } else if (snapshot.get('online') == 'online') {
            int diffTime = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(int.tryParse(snapshot.get('online_at')) ?? 1589455857958)).inMinutes;
            if (diffTime < 60) {
              updateUsersStatusList(snapshot.get('id'), true);
            } else {
              updateUsersStatusList(snapshot.get('id'), false);
            }
          } else {
            updateUsersStatusList(snapshot.get('id'), false);
          }
        }
      });
    });
  }

  updateUsersStatusList(String index, bool status) {
    Echo('updateUsersStatusList $index $status ');
    setState(() {
      updateOnlineStatus = !updateOnlineStatus;
    });
    usersStatusList[index] = status;
  }

  Widget widgetOnlineStatus(String userId, DocumentSnapshot document) {
    Echo('widgetOnlineStatus $userId  ');
    bool status = false;
    if (usersStatusList[userId] == null)
      return Positioned(
        bottom: 2,
        right: 2,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
            border: Border.all(width: 2.0, color: Colors.white),
          ),
        ),
      );
    else {
      usersStatusList.forEach((k, v) {
        if (k == document['user_id']) if (v) status = true;
      });
      return Positioned(
        bottom: 2,
        right: 2,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: status ? Colors.green : Colors.grey,
            border: Border.all(width: 2.0, color: Colors.white),
          ),
        ),
      );
    }
  }
}

class OnlineModel {
  int index;
  bool status;

  OnlineModel({this.index, this.status});
}
