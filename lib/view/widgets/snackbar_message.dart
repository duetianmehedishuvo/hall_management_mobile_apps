import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/palette.dart';
import 'package:flutter/material.dart';

void showMessage(String message, {bool isError = true}) {
  ScaffoldMessenger.of(Helper.navigatorKey.currentState!.context).showSnackBar(
    SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), backgroundColor: isError ? Colors.red : Palette.primary),
  );
}
