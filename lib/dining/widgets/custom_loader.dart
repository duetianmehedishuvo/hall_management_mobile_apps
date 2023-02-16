
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({this.color = Colors.teal, Key? key}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SpinKitFadingCircle(color: color, size: 40.0),
    );
  }
}
