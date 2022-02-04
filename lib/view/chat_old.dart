/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:starslive/constant/contant.dart';
import 'package:starslive/helper/chat_helper.dart';
import 'package:starslive/localization/AppLocalizations.dart';
import 'package:starslive/model/ChatModel.dart';
import 'package:starslive/model/UserModel.dart';
import 'package:starslive/repository/user_repository.dart';
import 'package:starslive/view/MessagingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsWidget extends StatefulWidget {
  @override
  _ChatsWidgetState createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: baseColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: Text(
            localized(context, 'messages'),
            style: GoogleFonts.cairo(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          bottom: TabBar(
            indicatorColor: Color(0xffFFC700),
            labelPadding: EdgeInsets.all(10),
            tabs: [
              Text(
                localized(context, 'messages'),
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              // Text(localized(context, 'status'),style: TextStyle(fontSize: 17,color: Colors.white),)
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChatWidget(),
            //_buildStatusWidget()
          ],
        ),
      ),
    );
  }

  _buildChatWidget() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      height: h,
      width: w,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<List<UserChatModel>>(
                future: ChatHelper.getUsersThatChatWith(
                    usersId: currentUser.value.id.toString()),
                builder: (context, snapshot) {
                  List<UserChatModel> usersChat;
                  if (snapshot.hasData) usersChat = snapshot.data;
                  return usersChat == null
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : usersChat.length == 0
                          ? Container(
                              child: Center(
                                child: Text("لا يوجد محادثات"),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              itemCount: usersChat.length,
                              itemBuilder: (context, i) {
                                return userChatWidget(usersChat[i]);
                              },
                            );
                }),
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  _buildStatusWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(5, (index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/img/person.png'),
                        fit: BoxFit.contain)),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'محمود جمال',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'user',
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: GoogleFonts.cairo(
                          color: Color(0xffC9C9C9),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget userChatWidget(UserChatModel model) {
    return StreamBuilder<QuerySnapshot>(
        stream: ChatHelper.getMessagesStream(
            currentUserId: currentUser.value.id.toString(), userId: model.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              List<QueryDocumentSnapshot> allMessageFromUser = snapshot
                  .data.docs
                  .where((e) =>
                      ChatModel.fromMap(e.data()).to ==
                      currentUser.value.id.toString())
                  .toList();
              List<bool> allMessageSeen = allMessageFromUser
                  .map((e) => ChatModel.fromMap(e.data()).seen)
                  .toList();
              model.unreadMessages =
                  allMessageSeen.where((e) => !e).toList().length;
              ChatModel message =
                  ChatModel.fromMap(snapshot.data.docs.first.data());
              if (message.message.length == 0)
                model.lastMessage = "attached image";
              else
                model.lastMessage = message.message;
            }
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessagingWidget(
                              userChatModel: model,
                            )));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: 84,
                      width: 81,
                      child: Stack(
                        children: [
                          Positioned(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.network(
                                model.image ?? "",
                                height: 64,
                                width: 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              child: model.unreadMessages > 0
                                  ? SizedBox()
                                  : Container(
                                      alignment: Alignment.topCenter,
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          color: Color(0xffFF8960)),
                                      child: Text(
                                        model.unreadMessages.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.name,
                          style: GoogleFonts.cairo(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          model.lastMessage,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )),
                    Text(
                      DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(model.messageTime.toString()))),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        color: Color(0xff1A74FF),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}

// class ChatItem extends StatefulWidget {
//   @override
//   _ChatItemState createState() => _ChatItemState();
// }
//
// class _ChatItemState extends State<ChatItem> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(context, MaterialPageRoute(builder: (context)=> MessagingWidget()));
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: 10,
//           vertical: 5
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               alignment: Alignment.topCenter,
//               height: 84,
//               width: 81,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(90),
//                       child: Image.network(
//                         model.image??"",
//                         height: 64,
//                         width: 64,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                       top: 0,
//                       child: model.unreadMessages>0? SizedBox():Container(
//                         alignment: Alignment.topCenter,
//                         height: 20,
//                         width: 20,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white,width: 2),
//                           color: Color(0xffFF8960)
//                         ),
//                         child: Text(
//                           '2',
//                           style: TextStyle(
//                             color: Colors.white,
//                               fontSize: 12
//                           ),
//                         ),
//                       )
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       'محمود عبدالله',
//                       style: GoogleFonts.cairo(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 17,
//                       ),
//                     ),
//                     Text(
//                       'في على صفحتها الخاص',
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.cairo(
//                         color: Color.fromRGBO(0, 0, 0, 0.2),
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 )
//             ),
//             Text(
//               '2.00 AM',
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.cairo(
//                 color: Color(0xff1A74FF),
//                 fontWeight: FontWeight.w400,
//                 fontSize: 15,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
*/


