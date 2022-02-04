import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helper/chat_helper.dart';
import '../model/User.dart';
import '../model/UserModel.dart';

import 'dart:async';
import 'package:image_picker/image_picker.dart';
import '../repository/user_repository.dart';
/*
class ChatScreenController extends ControllerMVC {
  // singleton
  factory ChatScreenController(){
    if (_this == null) _this = ChatScreenController._();
    return _this;
  }

  static ChatScreenController _this;
  ChatScreenController._();
  bool screenLoading = false;
  UserChatModel userChatModel;
  ScrollController controller;
  StreamController currentOffsetStream;
  TextEditingController messageController = TextEditingController();
  File messageFile;
  User CurUserData;

  initState(){
    CurUserData = currentUser.value;
    super.initState();
  }


  Future sendMessage()async{
    if(messageController.text.toString().trim().length>0||messageFile!=null){
      String imagePath;
      setState(()=> screenLoading = true);
      if(messageFile != null) imagePath = await ChatHelper.uploadImageToServer(image: messageFile);
      await ChatHelper.sendMessage(
        message: messageController.text,
        image: imagePath,
        fromId: CurUserData.id.toString(),
        toId: userChatModel.id,
      );
      setState((){
        screenLoading = false;
        messageFile = null;
        messageController.clear();
      });
    }
  }

  bool isLeftMessage({String fromId}){
    return fromId != currentUser.value.id.toString();
  }



  pickUpFile({bool fromCamera = false})async{
    // final File image = await ImagePicker.pickImage(source: fromCamera? ImageSource.camera:ImageSource.gallery);
    final imageFile = File(await ImagePicker().getImage(source:fromCamera? ImageSource.camera:ImageSource.gallery).then((pickedFile) => pickedFile.path));
    if(imageFile!=null){
      setState(() {
        messageFile = imageFile;
      });
    }
  }

}*/