import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../chat/chat_controller.dart';
import '../model/User.dart';

import '../helper/app_config.dart';
import '../helper/echo.dart';
import '../main_provider_model.dart';

class ShowUserProfileDialog extends StatefulWidget {
  final User profileData;
  final String channelId;
  final ClientRole myRole;
  final bool allowChallenge;
  final bool imAdmin;
  final kickUser;

  ShowUserProfileDialog({this.profileData, this.kickUser, this.imAdmin, this.allowChallenge, this.channelId, this.myRole});

  @override
  _ShowUserProfileDialogState createState() => _ShowUserProfileDialogState();
}

class _ShowUserProfileDialogState extends State<ShowUserProfileDialog> {
  bool sendChallenge = false;
  bool chatClickLoading = false;
  User profile;

  @override
  void initState() {
    profile = widget.profileData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);

    Echo('me id ${mainProviderModel.profileData.id}');
    Echo('me nam ${mainProviderModel.profileData.name}');

    Echo('user id ${profile.id}');
    Echo('user name ${profile.name}');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                  AppColors().primaryDarkColor(),
                  AppColors().primaryColor(),
                  Colors.deepOrange,
                ]),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //user brief data (image , name , button to follow or unfollow)
                  Container(
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                          AppColors().primaryLightColor(),
                          AppColors().primaryColor(),
                          AppColors().primaryDarkColor(),
                        ]),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 12),
                        Text(
                          profile.name,
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 6),
                        Stack(
                          children: [
                            Container(
                              width: 85,
                              height: 80,
                            ),
                            Positioned(
                              top: 15,
                              left: 15,
                              right: 15,
                              bottom: 15,
                              child: GestureDetector(
                                onTap: () {
                                  // RouteArgument argument = RouteArgument(param: '${profile.name}', id: '${profile.id}', heroTag: '${profile.id}');
                                  // Navigator.of(context).pushNamed(UserProfileController.id, arguments: argument);
                                },
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(100))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: profile.image,
                                        width: 75,
                                        height: 75,
                                        errorWidget: (context, url, error) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 17,
                                            ),
                                          );
                                        },
                                        placeholder: (context, url) {
                                          return CircularProgressIndicator();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //User premium items
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${profile.userLevel.level}',
                      style: TextStyle(color: AppColors().primaryColor(), fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8), SizedBox(height: 8),

                  Container(
                    child: chatClickLoading
                        ? Container(width: 30, height: 30, child: CircularProgressIndicator())
                        : GestureDetector(
                            onTap: () async {
                              setState(() {
                                chatClickLoading = true;
                              });
                              await addUserToMyContacts(context, '${profile.id}', profile.name, profile.image);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'محادثة',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 8),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addUserToMyContacts(BuildContext context, String userId, String userName, String userImage) async {
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
    //user is admin
    //check if user already in  own_contacts
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('stars-users').doc('${mainProviderModel.profileData.id}').collection('my-contacts').where('user_id', isEqualTo: userId).get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      String chatId = '${DateTime.now().millisecondsSinceEpoch}';

      //add user to my contacts
      Echo('add  user  to my contacts ');
      try {
        await FirebaseFirestore.instance.collection('stars-users').doc('${mainProviderModel.profileData.id}').collection('my-contacts').doc().set({
          'userName': userName,
          'userPhotoUrl': userImage,
          'user_id': userId,
          'last_message': '',
          'chat_id': chatId,
          'unread_count': 0,
          'created_at': chatId,
          'updated_at': '0',
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'errorr 23212');
      }
      Echo('add me to other user  ');
      //add me to other user contacts
      await FirebaseFirestore.instance.collection('stars-users').doc(userId).collection('my-contacts').doc().set({
        'userName': mainProviderModel.profileData.name,
        'userPhotoUrl': mainProviderModel.profileData.image,
        'user_id': '${mainProviderModel.profileData.id}',
        'last_message': '',
        'unread_count': 0,
        'chat_id': chatId,
        'created_at': chatId,
        'updated_at': '0',
      }).onError((error, stackTrace) {
        Echo('$error');
      });

      addUserToMyContacts(context, userId, userName, userImage);
    } else {
      Echo('user already in my contacts');

      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatController(
                    documentId: documents[0].id,
                    userId: documents[0].data()['user_id'],
                    userImage: documents[0].data()['userPhotoUrl'],
                    chatId: documents[0].data()['chat_id'],
                    chatWith: documents[0].data()['userName'],
                  )));
    }
  }

  sendChallengeRequest() async {
    Echo('send challenge request to ${profile.id}');
    if (sendChallenge) {
      FirebaseFirestore.instance.collection('stars').doc(widget.channelId).collection('${profile.id}').doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
        {
          'type': 'challenge',
        },
      );
    }
  }
}
