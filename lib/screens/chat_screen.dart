import 'dart:async';
import 'dart:developer';

import 'package:chat_gpt_fltr/constants/constants.dart';
import 'package:chat_gpt_fltr/providers/chats_provider.dart';
import 'package:chat_gpt_fltr/providers/models_provider.dart';
import 'package:chat_gpt_fltr/services/asstes_manager.dart';
import 'package:chat_gpt_fltr/services/services.dart';
import 'package:chat_gpt_fltr/widgets/chat_widget.dart';
import 'package:chat_gpt_fltr/widgets/text_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late final TextEditingController _textEditingController;
  late FocusNode focusNode;
  late ScrollController _listScrollController;

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void initState() {
    getConnectivity();
    focusNode = FocusNode();
    _textEditingController = TextEditingController();
    _listScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    _textEditingController.dispose();
    _listScrollController.dispose();
    subscription.cancel();
    super.dispose();
  }

  // List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("ChatGPT😈Ak srivastava"),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(AssetManager.openaiLogo),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context);
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: BottomNav(
        focusNode: focusNode,
        textEditingController: _textEditingController,
        onPressed: () async {
          await sendMessageFCT(
            modelsProvider: modelsProvider,
            chatProvider: chatProvider,
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
          child: Column(
            mainAxisAlignment: chatProvider.chatList.isEmpty
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              chatProvider.chatList.isEmpty
                  ? Flexible(
                      child: ListView(
                        children: [
                          const SizedBox(height: 100),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Hey there, I'm your AI chat and helping bot. How can I help you today?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Lottie.asset(AssetManager.robotLottie),
                          const SizedBox(height: 50),
                        ],
                      ),
                    )
                  : Flexible(
                      child: ListView.builder(
                          controller: _listScrollController,
                          itemCount: chatProvider.getChatLsit.length,
                          itemBuilder: (context, index) {
                            return ChatWidget(
                              msg: chatProvider.getChatLsit[index]
                                  .msg, // chatList[index].msg
                              chatIndex:
                                  chatProvider.getChatLsit[index].chatIndex,
                              shouldAnimate:
                                  chatProvider.getChatLsit.length - 1 == index,
                            );
                          }),
                    ),
              const SizedBox(height: 10),
              if (_isTyping) ...[
                const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(height: 15),
              ],

              /* Material(
                color: cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          controller: _textEditingController,
                          // onSubmitted: (value) async {
                          //   await sendMessageFCT(
                          //     modelsProvider: modelsProvider,
                          //     chatProvider: chatProvider,
                          //   );
                          // },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            hintText: "How can I help you?",
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider,
                          );
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ), */
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (!isDeviceConnected) return;
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You can't send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_textEditingController.text.isEmpty ||
        _textEditingController.text == " ") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = _textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMsg(msg: msg);
        _textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMsgAndGetAnswer(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }

  void scrollListToEnd() {
    _listScrollController.animateTo(
      _listScrollController.position.minScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  void scrollListToStart() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  showJailBreakDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Rooted!'),
          content: const Text('Can\'t proceed. Your phone is rooted!'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.focusNode,
    required this.textEditingController,
    required this.onPressed,
  });
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                controller: textEditingController,
                textInputAction: TextInputAction.newline,
                onSubmitted: (value) {
                  // foc
                  // await sendMessageFCT(
                  //   modelsProvider: modelsProvider,
                  //   chatProvider: chatProvider,
                  // );
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  hintText: "How can I help you?",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
  }) async {
    if (_textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(label: "Can not send an empty message"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      setState(() {
        _isTyping = true;
        // chatList.add(
        //   ChatModel(msg: _textEditingController.text, chatIndex: 0),
        // );
        chatProvider.addUserMsg(msg: _textEditingController.text);
        _textEditingController.clear();
        focusNode.unfocus();
      });
      log("Request has been sent!");
      await chatProvider.sendMsgAndGetAnswer(
        msg: _textEditingController.text,
        chosenModelId: modelsProvider.getCurrentModel,
      );
      // chatList.addAll(
      //   await ApiService.sendMessage(
      //     msg: _textEditingController.text,
      //     modelId: modelsProvider.getCurrentModel,
      //   ),
      // );
      setState(() {});
    } catch (err) {
      log("error=> $err");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(label: err.toString()),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isTyping = false;
        scrollListToEnd();
      });
    }
  } */