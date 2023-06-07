import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt_fltr/constants/constants.dart';
import 'package:chat_gpt_fltr/services/asstes_manager.dart';
import 'package:chat_gpt_fltr/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {super.key,
      required this.msg,
      required this.chatIndex,
      this.shouldAnimate = false});

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;

  @override
  Widget build(BuildContext context) {
    msgtext(String data) {
      var newData = SelectableText(data);
      return newData.toString();
    }

    var newMsg = msgtext(msg);
    return Column(
      children: [
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(chatIndex == 1 ? 10 : 0),
          ),
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetManager.userImage
                      : AssetManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: chatIndex == 0
                      ? TextWidget(
                          label: msg,
                        )
                      : shouldAnimate
                          ? SelectableText.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: AnimatedTextKit(
                                      isRepeatingAnimation: false,
                                      repeatForever: false,
                                      displayFullTextOnTap: true,
                                      totalRepeatCount: 1,
                                      animatedTexts: [
                                        TyperAnimatedText(
                                          msg,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Handle tap event here
                              },
                            )
                          : Text(
                              msg.trim(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                ),
                const SizedBox(width: 4),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
