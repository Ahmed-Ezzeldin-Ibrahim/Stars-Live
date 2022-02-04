import 'package:flutter/cupertino.dart';
import '../model/ChatModel.dart';
import '../repository/chats_repository.dart';

class ChatsProvider extends ChangeNotifier {
  Chat chat;

  getChatMessages() async {
    chat = await getMessagesData();
    notifyListeners();
  }

  sendChatMessage({String message, int receiver_id}) async {
    await sendMessagesData(message, receiver_id);
    notifyListeners();
  }
}
