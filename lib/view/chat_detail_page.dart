import 'package:flutter/material.dart';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../provider/chats_provider.dart';
import '../repository/user_repository.dart';

class ChatDetailPage extends StatefulWidget {
  final LocalFileSystem localFileSystem = LocalFileSystem();

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController msg = TextEditingController();

  Random random = new Random();
  var sendMessageController = TextEditingController();

  getBannerData() async {
    if (Provider
        .of<ChatsProvider>(context)
        .chat == null) {
      await Provider.of<ChatsProvider>(context, listen: false).getChatMessages()
          .whenComplete(() =>
          setState(() {}));
      //print(Provider.of<BannerProvider>(context, listen: false).b.status);
    } else {
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    getBannerData();
    return Consumer<ChatsProvider>(builder: (context, chat, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFfff0e3),
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.cyan[900],
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1614283233556-f35b0c801ef1?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=774&q=80"),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "user",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.cyan[900]),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Online",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  //  Icon(Icons.settings, color: Colors.black54,),
                ],
              ),
            ),
          ),
        ),
        body: Conditional.single (
          context: context,
          conditionBuilder: (context) => Provider.of<ChatsProvider>(context, listen: false).chat.data.isNotEmpty,
          fallbackBuilder: (context) => Center(
            child: Text("لا يوجد رسائل"),
          ),
          widgetBuilder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: Provider.of<ChatsProvider>(context, listen: false).chat.data.length,
                    separatorBuilder: (context, int) => SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      if (currentUser.value.id == Provider.of<ChatsProvider>(context, listen: false).chat.data[index].fromId)
                        return Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.only(
                                    bottomStart: Radius.circular(10.0),
                                    topEnd: Radius.circular(10.0),
                                    topStart: Radius.circular(10.0)),
                                color: Colors.grey[300],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Text(Provider.of<ChatsProvider>(context, listen: false).chat.data[index].message)),
                        );
                      else
                        return Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.only(
                                    bottomEnd: Radius.circular(10.0),
                                    topEnd: Radius.circular(10.0),
                                    topStart: Radius.circular(10.0)),
                                color: Colors.grey[300],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Text(Provider.of<ChatsProvider>(context, listen: false).chat.data[index].message)),
                        );
                    },
                  ),
                ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: sendMessageController,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.cyan[900],
                        ),
                        child: MaterialButton(
                          minWidth: 1,
                          onPressed: () {
                            chat.sendChatMessage(
                                message: sendMessageController.text,
                                receiver_id: 50
                            );
                            sendMessageController.clear();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 16,
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
