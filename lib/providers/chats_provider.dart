import 'package:chat_gpt_fltr/models/chat_model.dart';
import 'package:chat_gpt_fltr/services/api_service.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<ChatModel> get getChatLsit => chatList;

  //Setters
  void addUserMsg({required String msg}) {
    chatList.add(
      ChatModel(msg: msg, chatIndex: 0),
    );
    notifyListeners();
  }

  Future<void> sendMsgAndGetAnswer(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }
}
