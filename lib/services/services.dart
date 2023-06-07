import 'package:chat_gpt_fltr/constants/constants.dart';
import 'package:chat_gpt_fltr/widgets/drop_down.dart';
import 'package:chat_gpt_fltr/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showModalSheet(BuildContext context) async {
    await showModalBottomSheet(
        backgroundColor: scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                  child: TextWidget(
                    label: "Choosen Model:",
                    fontsize: 16,
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  flex: 2,
                  child: ModelDropDownWidget(),
                ),
                SizedBox(width: 15),
                Text(
                  "Hint: Please use default choosen model for perfect answer.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
