import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../constant/contant.dart';
import '../controller/ChatScreenController.dart';
import '../helper/chat_helper.dart';
import '../model/ChatModel.dart';
import '../model/UserModel.dart';
import '../repository/user_repository.dart';
import '../widget/LoadingScreen.dart';
import '../widget/ShowImagesWidget.dart';
/*
class MessagingWidget extends StatefulWidget {
  final UserChatModel userChatModel;
  MessagingWidget({Key key,@required this.userChatModel}) : super(key: key);

  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends StateMVC<MessagingWidget> {
  _MessagingWidgetState(): super(ChatScreenController()){
    con = controller;
  }
  ChatScreenController con;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    con.userChatModel = widget.userChatModel;
    con.currentOffsetStream = StreamController<double>.broadcast();
    con.controller = ScrollController(initialScrollOffset:  0.0);
    con.controller.addListener(() {
      con.currentOffsetStream.sink.add(con.controller.offset);
    });
    super.initState();
  }

  @override
  void dispose() {
    con.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // var applocal = AppLocalizations.of(context);
    return LoadingScreen(
      loading: con.screenLoading,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: baseColor,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios,size: 30,color: Colors.white,), onPressed: () => Navigator.of(context).pop(),),
          centerTitle: true,
          elevation: 0,
          title: Text(
           con.userChatModel.name,
            style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    con.userChatModel.image
                  ),
                  fit: BoxFit.fill,
                )
              ),
              height: 40,
              width: 40,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Container(
          height: h,
          width: w,
          padding: EdgeInsets.only(
              top: 10,bottom: 10
          ),
          child: StreamBuilder<double>(
              stream: con.currentOffsetStream.stream,
              initialData: 0.0,
            builder: (context, snapshot) {
              double scrollPosition = snapshot.data;
              return Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            'https://i.redd.it/qwd83nc4xxf41.jpg',
                          ),
                          fit: BoxFit.fill),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: ChatHelper.getMessagesStream(
                                  userId: con.userChatModel.id, currentUserId: con.CurUserData.id.toString()),
                              builder: (context, snapshot) {
                                List<ChatModel> messages;
                                if (snapshot.hasData) {
                                  messages = snapshot.data.docs.map((e) =>
                                      ChatModel.fromMap(e.data())).toList();
                                }
                                return Container(
                                  child: messages==null?
                                  Container(
                                    child: Center(child: CircularProgressIndicator()),
                                  ):
                                  ListView.builder(
                                    reverse: true,
                                    controller: con.controller,
                                    itemCount: messages.length,
                                    itemBuilder: (context,i){
                                      if(messages[i].from == con.userChatModel.id  && !messages[i].seen){
                                        ChatHelper.updateMessageSeen(
                                            userId: con.userChatModel.id,
                                            currentUserId: currentUser.value.id.toString(),
                                            docMessageId: snapshot.data.docs[i].id);
                                      }
                                      return con.isLeftMessage(fromId: messages[i].from)?
                                      leftMessage(messages[i],context):
                                      rightMessage(messages[i],context);
                                    },
                                  ),
                                );
                              }
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10,left: 10,right: 10,top: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: con.messageController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: con.messageFile!=null?
                                    Stack(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: Image.file(
                                                con.messageFile,fit: BoxFit.fill,height: 60,width: 60,),
                                            )
                                        ),
                                        Positioned(
                                          top: 5,
                                          left: 0,
                                          child: InkWell(
                                            onTap: (){
                                              setState(() {con.messageFile = null;});
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.close,color: Colors.white,size: 25,)),
                                          ),
                                        )
                                      ],
                                    ) :null,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(41, 57, 101, 1)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(41, 57, 101, 1)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: "اكتب رسالتك ...",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(41, 57, 101, 1)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                                    icon: InkWell(
                                      onTap: () {
                                        final action = CupertinoActionSheet(
                                          message: Text(
                                            'image',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          actions: <Widget>[
                                            CupertinoActionSheetAction(
                                              onPressed: () => con.pickUpFile(fromCamera: true)
                                                  .then((value) => Navigator.pop(context)),
                                              child: Text(
                                                'Camera',
                                                style:
                                                TextStyle(color: Colors.black),
                                              ),
                                            ),
                                            CupertinoActionSheetAction(
                                              onPressed: ()=> con.pickUpFile().then((value)
                                              => Navigator.pop(context)),
                                              child: Text(
                                                'Gallery',
                                                style:
                                                TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ],
                                          cancelButton: CupertinoActionSheetAction(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(color: Colors.redAccent),
                                            ),
                                          ),
                                        );
                                        showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) => action);
                                      },
                                      child: Icon(Icons.attachment_outlined,
                                        color: Color.fromRGBO(41, 57, 101, 1),size: 30,),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 10,),
                              InkWell(
                                onTap: con.sendMessage,
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(41, 57, 101, 1),
                                      shape: BoxShape.circle
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  if(scrollPosition>20) Positioned(
                    bottom: 75,
                    right: 15,
                    child: InkWell(
                      onTap: (){
                        con.controller.animateTo(0.0, curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(61, 107, 191, 1),
                        ),
                        padding: EdgeInsets.all(10),
                        child: RotatedBox(
                            quarterTurns: 0,
                            child: Icon(Icons.arrow_downward_rounded,color: Colors.white,)),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget leftMessage(ChatModel message,BuildContext context){
    return Container(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: 250,
        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: message.image!=null?
                showMessageWithImage(message.image,message.message,false,context):
                Text(message.message??"",style: TextStyle(fontSize: 18,color: Colors.black),)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("${timeFromMillSecSinEpoch(message.time).format(context)}",
                    style: TextStyle(fontSize: 14,color: Colors.grey.shade600,height: 0.75),)),
            ),
          ],
        ),
      ),
    );
  }


  Widget rightMessage(ChatModel message,BuildContext context){
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Container(
            width: 250,
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: message.image!=null?
                    showMessageWithImage(message.image,message.message,true,context):
                    Text(message.message??"",style: TextStyle(fontSize: 18,color: Colors.black),)),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("${timeFromMillSecSinEpoch(message.time).format(context)}",
                    style: TextStyle(fontSize: 14,color: Colors.grey.shade600,height: 1),),
                ),
              ],
            ),
          ),
          Icon(message.seen?Icons.check_circle:Icons.check_circle_outline,
            color: message.seen?Colors.blue:Colors.grey,)
        ],
      ),
    );
  }

  Widget showMessageWithImage(String image,String message,bool isRight,BuildContext context){
    return Column(
      crossAxisAlignment: !isRight?CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isRight?15:0),
            topRight: Radius.circular(isRight?0:15),
          ),
          child: InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>ShowImagesWidget(
                      images: [image],
                    )));
              },child: Image.network(image,fit: BoxFit.fitWidth,)),
        ),
        if(message.length>0) SizedBox(height: 10,),
        Text(message,style: TextStyle(fontSize: 18,color: Colors.black))
      ],
    );
  }

  TimeOfDay timeFromMillSecSinEpoch(String time){
    return TimeOfDay(
        hour: DateTime.fromMillisecondsSinceEpoch(int.tryParse(time)).hour,
        minute: DateTime.fromMillisecondsSinceEpoch(int.tryParse(time)).minute
    );
  }
}*/
