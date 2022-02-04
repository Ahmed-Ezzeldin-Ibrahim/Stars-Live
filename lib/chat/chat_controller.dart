import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../model/route_argument.dart';

import '../helper/app_config.dart';
import '../helper/echo.dart';
import '../main_provider_model.dart';
import 'chat_view.dart';

class ChatController extends StatefulWidget {
  final String userId;
  final String userImage;
  final String chatId;
  final String documentId;
  final String chatWith;

  const ChatController({
    Key key,
    @required this.documentId,
    @required this.userId,
    @required this.userImage,
    @required this.chatId,
    @required this.chatWith,
  }) : super(key: key);

  @override
  _ChatControllerState createState() => _ChatControllerState();
}

class _ChatControllerState extends State<ChatController> {
  String userImage;
  var listMessage;

//  SharedPreferences prefs;

  File imageFile;
  File fileFile;
  bool isLoading;
  bool isShowSticker;

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    resetLastMessageCount(context, widget.documentId);
    focusNode.addListener(onFocusChange);
    isLoading = false;
    isShowSticker = false;
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void onSendMessage(
    String content,
    int type,
  ) async {
    print('type = $type');
    // type: 0 = text, 1 = image, 2 = sticker

    if (content.trim() != '') {
      updateLastMessage(widget.userId, content, type, widget.chatId);

      /* listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);*/
      //send chat
      try {
        FirebaseFirestore.instance.collection('stars-messages').doc('private').collection(widget.chatId).doc('${DateTime.now().millisecondsSinceEpoch}'.toString()).set(
          {
            'idFrom': '${mainProviderModel.profileData.id}',
            'idTo': widget.userId,
            'timestamp': '${DateTime.now().millisecondsSinceEpoch}',
            'content': content,
            'type': type,
            'read': 'unread',
          },
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'error 565458');
      }
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  // ignore: missing_return
  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  MainProviderModel mainProviderModel;
  @override
  Widget build(BuildContext context) {
    mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors().primaryColor(),
        title: GestureDetector(
          onTap: () {
            RouteArgument argument = RouteArgument(param: '${widget.chatWith}', id: '${widget.userId}', heroTag: '${widget.userId}');
            // Navigator.of(context).pushNamed(UserProfileController.id, arguments: argument);
          },
          child: new Text(
            widget.chatWith,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
            AppColors().primaryLightColor(),
            AppColors().primaryColor(),
            AppColors().primaryDarkColor(),
          ]),
        ),
        child: ChatView(
            onSendMessage: onSendMessage,
            isLoading: isLoading,
            onBackPress: onBackPress,
            showSticker: getSticker,
            userImage: widget.userImage,
            chatId: widget.chatId,
            focusNode: focusNode,
            userId: widget.userId,
            updateReadStatus: updateReadStatus,
            isShowSticker: isShowSticker),
      ),
    );
  }

  void updateLastMessage(String otherUserId, String content, int type, String chatId) async {
    if (otherUserId != null && mainProviderModel.profileData.id != null && widget.chatId != null) {
      //Update last message and count for other user
      final QuerySnapshot referenceToOtherUserContacts =
          await FirebaseFirestore.instance.collection('stars-users').doc(otherUserId).collection('my-contacts').where('user_id', isEqualTo: '${mainProviderModel.profileData.id}').get();
      final List<DocumentSnapshot> referenceToOtherUserContactsId = referenceToOtherUserContacts.docs;

      if (referenceToOtherUserContactsId != null && referenceToOtherUserContactsId.length > 0) {
        final QuerySnapshot calculateUnreadMessagesForOtherUser =
            await FirebaseFirestore.instance.collection('stars-messages').doc('private').collection(widget.chatId).where('idTo', isEqualTo: otherUserId).where('read', isEqualTo: 'unread').get();
        final List<DocumentSnapshot> calculateUnreadMessagesForOtherUserList = calculateUnreadMessagesForOtherUser.docs;

        Echo('calculateUnreadMessagesForOtherUserList ${calculateUnreadMessagesForOtherUserList.length}');
        Echo('referenceToOtherUserContactsId ${referenceToOtherUserContactsId[0].id}');

        FirebaseFirestore.instance.collection('stars-users').doc(otherUserId).collection('my-contacts').doc(referenceToOtherUserContactsId[0].id).update({
          'last_message': type == 0
              ? content
              : type == 2
                  ? 'Sticker'
                  : type == 1
                      ? 'Image'
                      : 'File',
          'unread_count': calculateUnreadMessagesForOtherUserList.length == null ? 1 : calculateUnreadMessagesForOtherUserList.length,
          'updated_at': '${DateTime.now().millisecondsSinceEpoch}'
        });

        //Update last message and count for me
        final QuerySnapshot referenceToUserContacts =
            await FirebaseFirestore.instance.collection('stars-users').doc('${mainProviderModel.profileData.id}').collection('my-contacts').where('user_id', isEqualTo: otherUserId).get();
        final List<DocumentSnapshot> referenceToUserContactsId = referenceToUserContacts.docs;

        FirebaseFirestore.instance.collection('stars-users').doc('${mainProviderModel.profileData.id}').collection('my-contacts').doc(referenceToUserContactsId[0].id).update({
          'last_message': type == 0
              ? content
              : type == 2
                  ? 'Sticker'
                  : type == 1
                      ? 'Image'
                      : 'File',
          'unread_count': 0,
          'updated_at': '${DateTime.now().millisecondsSinceEpoch}'
        });
      }
    }
  }

  void updateReadStatus(String readStatus, String documentID) {
    resetLastMessageCount(context, widget.documentId);
    if (readStatus != 'read') {
      FirebaseFirestore.instance.collection('stars-messages').doc('private').collection(widget.chatId).doc(documentID).update(
        {
          'read': 'read',
        },
      );
    }
  }

  void resetLastMessageCount(BuildContext context, String referenceToUserContactsId) async {
    if (mainProviderModel != null && mainProviderModel.profileData != null)
      FirebaseFirestore.instance.collection('stars-users').doc('${mainProviderModel.profileData.id}').collection('my-contacts').doc(referenceToUserContactsId).update({
        'unread_count': 0,
      });
  }
}
