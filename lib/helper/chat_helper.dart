/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:starslive/helper/FireBaseFireStoreHelper.dart';
import 'package:starslive/model/ChatModel.dart';
import 'package:starslive/model/User.dart';
import 'package:starslive/model/UserModel.dart';
import '../repository/user_repository.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:path/path.dart';

class ChatHelper{
  static final String usersTable = "users";
  static final String chatTable = "chats";


  static addUser({UserChatModel user,String userChatWithId})async{
    bool isUserExist = await FireBaseFireStoreHelper.detectIsItemFound(
        tableName: ChatHelper.usersTable,userId: user.id);

    if(!isUserExist) {
      if(userChatWithId!=null) user.chattingWith.add(userChatWithId);
      await FireBaseFireStoreHelper.addToCollectionWithId(id: user.id,
          tableName: ChatHelper.usersTable,data: user.toMap());
    }
  }

  static updateUser({UserChatModel user})async{
    bool isUserExist = await FireBaseFireStoreHelper.detectIsItemFound(
        tableName: ChatHelper.usersTable,userId: user.id);
    if(isUserExist) {
      await FireBaseFireStoreHelper.updateItemById(
          tableName: ChatHelper.usersTable, id: user.id, data: user.toMap());
    }
  }

  static addChatToUser({@required String userId ,@required String currentUserId}) async{
    UserChatModel currentUser = UserChatModel.fromMap(
        await FireBaseFireStoreHelper.getItemById(ChatHelper.usersTable, currentUserId));
     if(!currentUser.chattingWith.contains(userId)){
       currentUser.chattingWith.add(userId);
       await FireBaseFireStoreHelper.updateItemById(tableName: ChatHelper.usersTable,
           id: currentUserId, data: currentUser.toMap());
     }
  }


  static Future checkIfUserNotFound({bool canUpdate = true})async{
    User CurUserData = currentUser.value;
    bool isUserExist = await FireBaseFireStoreHelper.detectIsItemFound(
        tableName: ChatHelper.usersTable,userId: CurUserData.id.toString());
    print("checkIfUserNotFound  ${isUserExist}");
    print("checkIfUserNotFound  ${currentUser.value.id}");
    if(!isUserExist){
      ChatHelper.addUser(
        user: UserChatModel(
          id: CurUserData.id.toString(),
          image: CurUserData?.image == null?"":CurUserData.image,
          name: CurUserData.name,
          type: 1,
          createdAt: DateTime.now(),
        ),
      );
    }else{
      ChatHelper.updateUser(
        user: UserChatModel(
          id: CurUserData.id.toString(),
          image: CurUserData?.image == null?"":CurUserData.image,
          name: CurUserData.name,
          type: 1,
        ),
      );
    }
  }



  static Future<DocumentReference> getMessageReference({String groupChatId}) async{
    return FirebaseFirestore.instance.collection(ChatHelper.chatTable).
    doc(groupChatId).collection(groupChatId).doc(DateTime.now().millisecondsSinceEpoch.toString());
  }

  static Future sendMessage({String message,String image,String fromId, String toId})async{
    String groupChatId = getGroupChatId(currentUserId: fromId,userId: toId);
    DocumentReference documentReference = await getMessageReference(groupChatId: groupChatId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(documentReference, ChatModel(message: message,image: image,
          from: fromId, to: toId, time: DateTime.now().millisecondsSinceEpoch.toString()).toMap(),);
    });
    await FireBaseFireStoreHelper.updateItemById(tableName: ChatHelper.usersTable,
        id: toId, data: UserChatModel.messageTimeNowMap());
    await FireBaseFireStoreHelper.updateItemById(tableName: ChatHelper.usersTable,
        id: fromId, data: UserChatModel.messageTimeNowMap());
  }

  static updateMessageSeen({String currentUserId,String userId,String docMessageId}) async{
    String groupChatId = getGroupChatId(currentUserId: currentUserId,userId: userId);
    DocumentReference documentReference = await FirebaseFirestore.instance
        .collection(ChatHelper.chatTable).doc(groupChatId).collection(groupChatId).doc(docMessageId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.update(documentReference, ChatModel.seenMap(),);
    });
  }

  static Stream<QuerySnapshot> getMessagesStream({String currentUserId,String userId}){
    String groupChatId = getGroupChatId(currentUserId: currentUserId,userId: userId);
    return FirebaseFirestore.instance.collection(ChatHelper.chatTable)
        .doc(groupChatId).collection(groupChatId)
        .orderBy(ChatModel.timeKey, descending: true).snapshots();
  }

  static Future<List<UserChatModel>> getUsersThatChatWith({String usersId})async{
    print("?>>>>>>>>>>>>>>>>:::::${usersId}");
    List<UserChatModel> usersResult = [];
      List userMap = await FireBaseFireStoreHelper.getItemChatWithById(ChatHelper.usersTable, usersId);
      for(int i =0; i< userMap.length; i++) {
      if (userMap != null) {
        print("LLLLLLLLLLL${userMap.length}");
        UserChatModel user = UserChatModel.fromMap(userMap[i]);
        usersResult.add(user);
      }
    }
    if(usersResult.length >= 2 && usersResult.last.messageTime != null) {
      usersResult.sort((a, b) => (b.messageTime??DateTime.now()).compareTo(a.messageTime??DateTime.now()));
      return usersResult;
    }else{
      return usersResult;
    }
  }

  static Stream<QuerySnapshot> getUsersThatChatWithStream({List<String> idsUsers}){
    if(idsUsers.length==0) idsUsers = ["0"];
    return FirebaseFirestore.instance.collection(ChatHelper.usersTable).where(
        "id", whereIn: idsUsers).snapshots();
  }

  static Stream<QuerySnapshot> getCurrentUserStream({String userId}){
    return FirebaseFirestore.instance.collection(ChatHelper.usersTable).where(
        "id", isEqualTo: userId).snapshots();
  }

  static Future<String> uploadImageToServer({File image})async{
    Response response = await Dio().post(
        'https://matlfash.jaderplus.com/api/upload_chat_image',
      data: FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path, filename: basename(image.path)),
      }),
    );
    return response.data["data"];
  }

  static String getGroupChatId({String currentUserId,String userId}){
    String groupChatId;
    if (currentUserId.hashCode <= userId.hashCode) {
      groupChatId = '${currentUserId}-${userId}';
    } else {
      groupChatId = '${userId}-${currentUserId}';
    }

    return groupChatId;
  }
}*/