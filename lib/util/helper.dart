import 'dart:developer';

import 'package:duetstahall/helper/animation/slideleft_toright.dart';
import 'package:duetstahall/helper/animation/slideright_toleft.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

showLog(message) {
  log("APP SAYS: $message");
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

Widget singleItemWithKeyValue(String key, String value) {
  return Row(
    children: [
      Text(key, style: robotoStyle600SemiBold.copyWith(color: Colors.black, fontSize: 15)),
      const SizedBox(width: 5),
      Expanded(child: Text(value, style: robotoStyle400Regular.copyWith(fontSize: 16))),
    ],
  );
}

Widget noDataAvailable() {
  return Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text('No Data Available', style: robotoStyle500Medium.copyWith(fontSize: 16))));
}

Widget singleItemWithKeyValueAndCopy(String key, String value) {
  return Row(
    children: [
      Expanded(child: singleItemWithKeyValue(key, value)),
      InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            showMessage('Copy Successfully', isError: false);
          },
          child: Icon(Icons.copy))
    ],
  );
}

double screenHeight() {
  return MediaQuery.of(Helper.navigatorKey.currentState!.context).size.height;
}

double screenWeight() {
  return MediaQuery.of(Helper.navigatorKey.currentState!.context).size.width;
}

class Helper {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static toScreen(screen) {
    Navigator.push(navigatorKey.currentState!.context, SlideRightToLeft(page: screen));
  }

  static back() {
    Navigator.of(navigatorKey.currentState!.context).pop();
  }

  static toReplacementScreenSlideRightToLeft(screen) {
    Navigator.pushReplacement(navigatorKey.currentState!.context, SlideRightToLeft(page: screen));
  }

  static toReplacementScreenSlideLeftToRight(screen) {
    Navigator.pushReplacement(navigatorKey.currentState!.context, SlideLeftToRight(page: screen));
  }

  static toRemoveUntilScreen(screen) {
    Navigator.pushAndRemoveUntil(navigatorKey.currentState!.context, SlideRightToLeft(page: screen), (route) => false);
  }

  static onWillPop(screen) {
    Navigator.pushAndRemoveUntil(navigatorKey.currentState!.context, SlideRightToLeft(page: screen), (route) => false);
  }

  static showSnack(context, message, {color = colorPrimaryLight, duration = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 14)), backgroundColor: color, duration: Duration(seconds: duration)));
  }

  static circularProgress(context) {
    const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(colorPrimaryLight)));
  }

  static boxDecoration(Color color, double radius) {
    BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(radius)));
  }
}
