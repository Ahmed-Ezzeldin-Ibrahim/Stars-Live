import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_provider_model.dart';
import '../model/User.dart';
import '../repository/user_repository.dart';
import 'show_user_profile_dialog.dart';

class SingleChatView extends StatelessWidget {
  final int index;
  final DocumentSnapshot document;
  final double width;
  final ClientRole role;
  final String channelId;
  final int usersLength;
  final bool imAdmin;
  final sendKickUsersToSteam;

  SingleChatView({this.index, this.sendKickUsersToSteam, this.imAdmin = false, this.document, this.channelId, this.role, this.width, this.usersLength});

  bool visitUserProfileLoading = false;

  @override
  Widget build(BuildContext context) {
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
    if (document.get('message') == null || document.get('name') == null) return Container();
    return GestureDetector(
      onTap: () async {
        if ('${document.get('id')}' != '${mainProviderModel.profileData.id}') {
          if (!visitUserProfileLoading) {
            visitUserProfileLoading = true;
            try {
              User response = await getUserById(context, userId: '${document.get('id')}');

              showDialog(
                  context: context,
                  builder: (_) {
                    return ShowUserProfileDialog(
                      profileData: response,
                      myRole: role,
                      channelId: channelId,
                      allowChallenge: usersLength < 2,
                      imAdmin: imAdmin,
                      kickUser: (String userId, String userName) {},
                    );
                  });

              visitUserProfileLoading = false;
            } catch (error) {
              visitUserProfileLoading = false;
            }
          }
        }
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Opacity(
              opacity: 1 /*- (0.1 * index)*/,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //level
                          Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                '${document.get('level')}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),

                          SizedBox(width: 4),
                          //name
                          if (document.data().containsKey('name'))
                            Text(
                              document.get('name'),
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          SizedBox(width: 4),
                          //message
                          if (document.data().containsKey('message'))
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Text(
                                document.get('message'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),

                          SizedBox(width: 4),
                          //chat image sticker

                          if (document.data().containsKey('chat_image') && document.get('chat_image') != null && document.get('chat_image').toString().isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: document.get('chat_image').toString(),
                              width: 60,
                              height: 60,
                              errorWidget: (context, url, error) {
                                return Container();
                              },
                              placeholder: (context, url) {
                                return Container();
                              },
                            ),

                          if (document.data().containsKey('image') && document.get('image') != null)
                            CachedNetworkImage(
                              imageUrl: document.get('image'),
                              width: 60,
                              height: 60,
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
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyBlinkingButton extends StatefulWidget {
  final String imagel;

  MyBlinkingButton(this.imagel);

  @override
  _MyBlinkingButtonState createState() => _MyBlinkingButtonState();
}

class _MyBlinkingButtonState extends State<MyBlinkingButton> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: CachedNetworkImage(
        imageUrl: widget.imagel,
        width: 25,
        height: 25,
        errorWidget: (context, url, error) {
          return Container();
        },
        placeholder: (context, url) {
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
