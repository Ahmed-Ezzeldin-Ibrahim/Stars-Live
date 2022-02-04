import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helper/app_config.dart';
import '../main_provider_model.dart';
import '../model/route_argument.dart';
import 'fullPhoto.dart';

var _listMessage;

class ChatView extends StatefulWidget {
  final onSendMessage;
  final isLoading;
  final userId;
  final showSticker;
  final isShowSticker;
  final onBackPress;
  final userImage;
  final chatId;
  final updateReadStatus;
  final focusNode;

  ChatView(
      {@required this.onSendMessage,
      @required this.isLoading,
      @required this.onBackPress,
      @required this.userId,
      @required this.showSticker,
      @required this.userImage,
      @required this.chatId,
      @required this.focusNode,
      @required this.updateReadStatus,
      @required this.isShowSticker});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  MainProviderModel mainProviderModel;

  @override
  Widget build(BuildContext context) {
    mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
    double width = (MediaQuery.of(context).size.width / 1.3);
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(width),

              // Sticker
              (widget.isShowSticker ? buildSticker() : Container()),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: widget.onBackPress,
    );
  }

  Widget buildItem({BuildContext context, int index, DocumentSnapshot document, double width}) {
    // Right (my message)
    if (document['idFrom'] == '${mainProviderModel.profileData.id}') {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (document['type'] == 0)
                ChatMessageTextRight(
                  document: document,
                  index: index,
                  chatId: widget.chatId,
                ),
              if (document['type'] == 2) chatMessageStickerRight(context, document, width, index),
              chatMessageReadStatus(context, document, width, index),
            ],
          ),
//          chatMessageTimeRight(context, document, width, index),
        ],
      );
    }
    // Left (peer message)
    else {
      //      change read status to read
      widget.updateReadStatus(document['read'], document.id);
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isLastMessageLeft(index)
                    ? GestureDetector(
                        onTap: () {
                          RouteArgument argument = RouteArgument(param: '${''}', id: '${widget.userId}', heroTag: '${widget.userId}');
                          // Navigator.of(context).pushNamed(UserProfileController.id, arguments: argument);
                        },
                        child: Material(
                          child: Container(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: Icon(
                                  Icons.account_circle,
                                  color: Colors.deepPurple,
                                  size: 40,
                                ),
                                width: 40.0,
                                height: 40.0,
                              ),
                              imageUrl: widget.userImage,
                              width: 40.0,
                              height: 40.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                      )
                    : Container(width: 35.0),
                SizedBox(width: 2),
                if (document['type'] == 0) chatMessageTextLeft(context, document, width, index),
                if (document['type'] == 2) chatMessageStickerLeft(context, document, width, index),
              ],
            ),
//            chatMessageTimeLeft(context, document, width, index),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  widget.onSendMessage('mimi1', 2);
                  textEditingController.clear();
                },
                child: new Image.asset(
                  'assets/images/mimi1.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () {
                  widget.onSendMessage('mimi2', 2);
                  textEditingController.clear();
                },
                child: new Image.asset(
                  'assets/images/mimi2.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => widget.onSendMessage('mimi3', 2),
                child: new Image.asset(
                  'assets/images/mimi3.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => widget.onSendMessage('mimi4', 2),
                child: new Image.asset(
                  'assets/images/mimi4.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => widget.onSendMessage('mimi5', 2),
                child: new Image.asset(
                  'assets/images/mimi5.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => widget.onSendMessage('mimi6', 2),
                child: new Image.asset(
                  'assets/images/mimi6.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => widget.onSendMessage('mimi7', 2),
                child: new Image.asset(
                  'assets/images/mimi7.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => widget.onSendMessage('mimi8', 2),
                child: new Image.asset(
                  'assets/images/mimi8.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => widget.onSendMessage('mimi9', 2),
                child: new Image.asset(
                  'assets/images/mimi9.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: new BoxDecoration(border: new Border(top: new BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: widget.isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 51.0,
      decoration: new BoxDecoration(color: Colors.white.withOpacity(0.9), border: new Border.all(color: AppColors().primaryColor(opacity: 0.6)), borderRadius: BorderRadius.all(Radius.circular(40))),
      child: Row(
        children: <Widget>[
//          Material(
//            child: new Container(
//              margin: new EdgeInsets.symmetric(horizontal: 1.0),
//              child: new IconButton(
//                icon: new Icon(Icons.attach_file),
//                onPressed: () {
////                  widget.getFile();
//                },
//                color: Colors.blue,
//              ),
//            ),
//            color: Colors.white,
//          ),
          // new Container(
          //   margin: new EdgeInsets.symmetric(horizontal: 1.0),
          //   child: new IconButton(
          //     icon: new Icon(Icons.card_giftcard),
          //     onPressed: () {
          //       setState(() {});
          //     },
          //     color: Colors.deepPurple,
          //   ),
          // ),

          // Edit text
          Flexible(
            child: TextFormField(
              style: TextStyle(color: Colors.black, fontSize: 10.0),
              controller: textEditingController,
              focusNode: widget.focusNode,
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'اكتب رسالتك ...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onEditingComplete: () {
                widget.onSendMessage(textEditingController.text, 0);
                textEditingController.clear();
              },
            ),
          ),

          // Button send message
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 8.0),
            child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: () {
                widget.onSendMessage(textEditingController.text, 0);
                textEditingController.clear();
              },
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListMessage(double width) {
    return Flexible(
      child:
          /*groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple)))
          : */
          StreamBuilder(
        stream: FirebaseFirestore.instance.collection('stars-messages').doc('private').collection(widget.chatId).orderBy('timestamp', descending: true).limit(30).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple)));
          } else {
            _listMessage = snapshot.data.docs;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildItem(index: index, document: snapshot.data.docs[index], context: context, width: width),
              itemCount: snapshot.data.docs.length,
              reverse: true,
//              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && _listMessage != null && _listMessage[index - 1]['idFrom'] == '${mainProviderModel.profileData.id}') || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    /* if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] != _profile.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }*/
    return false;
  }

  Widget chatMessageImageRight(BuildContext context, DocumentSnapshot document, double width, int index) {
    return Column(
      children: <Widget>[
        Container(
          child: FlatButton(
            child: Material(
              child: GestureDetector(
                onLongPress: () {
//                  AwesomeDialog(
//                      context: context,
//                      dialogType: DialogType.INFO,
//                      animType: AnimType.SCALE,
//                      title: 'Delete message?',
//                      desc: '',
//                      btnCancelOnPress: () {},
//                      btnOkOnPress: () {
//                        FirebaseFirestore.instance
//                            .collection('1messages')
//                            .doc('private')
//                            .collection(widget.chatId)
//                            .doc(document.id)
//                            .update({
//                          'content': 'Message has been deleted',
//                          'type': '0',
//                        });
//                      }).show();
                },
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(70.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Material(
                    child: Image.asset(
                      'assets/images/img_not_available.jpeg',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document['content'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              clipBehavior: Clip.hardEdge,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
            },
            padding: EdgeInsets.all(0),
          ),
          margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget chatMessageStickerRight(BuildContext context, DocumentSnapshot document, double width, int index) {
    return Container(
      margin: EdgeInsets.only(right: 20.0, left: 20),
      child: CachedNetworkImage(
        imageUrl: document['content'],
        width: 60.0,
        height: 60.0,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget chatMessageTimeRight(BuildContext context, DocumentSnapshot document, double width, int index) {
    return Container(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.only(right: 35, bottom: 6, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            document['timestamp'] != null
                ? document['timestamp'] is String
                    ? ''
                    : DateFormat('dd MMM kk:mm').format(document['timestamp'].toDate()).toString()
                : '',
            style: TextStyle(color: Colors.grey, fontSize: 10.0, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget chatMessageReadStatus(BuildContext context, DocumentSnapshot document, double width, int index) {
    return document['read'] != null
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: document['read'] == 'read'
                ? Icon(
                    Icons.done_all,
                    color: Colors.green.shade700,
                    size: 20,
                  )
                : Icon(Icons.check, color: Colors.grey, size: 14))
        : Container();
  }

  Widget chatMessageTextLeft(BuildContext context, DocumentSnapshot document, double width, int index) {
    return Container(
      constraints: BoxConstraints(minWidth: 20, maxWidth: width),
      child: Text(
        document['content'],
        style: TextStyle(color: Colors.black, fontSize: 15),
      ),
      padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.symmetric(vertical: 6),
    );
  }

  Widget chatMessageImageLeft(BuildContext context, DocumentSnapshot document, double width, int index) {
    return Column(
      children: <Widget>[
        Container(
          child: FlatButton(
            child: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                  width: 200.0,
                  height: 200.0,
                  padding: EdgeInsets.all(70.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Material(
                  child: Image.asset(
                    'assets/images/img_not_available.jpeg',
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                imageUrl: document['content'],
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              clipBehavior: Clip.hardEdge,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
            },
            padding: EdgeInsets.all(0),
          ),
          margin: EdgeInsets.only(left: 10.0),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget chatMessageStickerLeft(BuildContext context, DocumentSnapshot document, double width, int index) {
    return Container(
      margin: EdgeInsets.only(right: 20.0, left: 20),
      child: CachedNetworkImage(
        imageUrl: document['content'],
        width: 60.0,
        height: 60.0,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget chatMessageTimeLeft(BuildContext context, DocumentSnapshot document, double width, int index) {
    return Container(
      margin: EdgeInsets.only(left: 51.0, bottom: 6, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            document['timestamp'] != null
                ? document['timestamp'] is String
                    ? ''
                    : DateFormat('dd MMM kk:mm').format(document['timestamp'].toDate()).toString()
                : '',
            style: TextStyle(color: Colors.grey, fontSize: 10.0, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class ChatMessageTextRight extends StatefulWidget {
  final DocumentSnapshot document;
  final int index;
  final String chatId;

  const ChatMessageTextRight({this.document, this.index, this.chatId});

  @override
  _ChatMessageTextRightState createState() => _ChatMessageTextRightState();
}

class _ChatMessageTextRightState extends State<ChatMessageTextRight> {
  bool showDeleteAction = false;

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width / 1.3);
    return Row(
      children: <Widget>[
        if (showDeleteAction)
          GestureDetector(
            onTap: () {
              FirebaseFirestore.instance.collection('1messages').doc('private').collection(widget.chatId).doc(widget.document.id).update({
                'content': 'Message has been deleted',
              });

              setState(() {
                showDeleteAction = !showDeleteAction;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
        Container(
          constraints: BoxConstraints(minWidth: 20, maxWidth: width),
          child: GestureDetector(
            onTap: () {
//                setState(() {
//                  showDeleteAction = !showDeleteAction;
//                });
            },
            child: Text(
              widget.document['content'],
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
          padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          margin: EdgeInsets.symmetric(vertical: 6),
//                  width: 200.0,
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8.0)),
        )
      ],
    );
  }
}
