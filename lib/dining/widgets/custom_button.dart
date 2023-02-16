import 'package:duetstahall/util/image.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? btnTxt;
  final Color? backgroundColor;
  final double? height;
  final bool? isStroked;
  final bool? isShowRightIcon;
  final IconData? iconData;
  final double? fontSize;
  final double? radius;

  const CustomButton(
      {this.onTap,
      @required this.btnTxt,
      this.backgroundColor=Colors.teal,
      this.height = 50.0,
      this.fontSize = 14.0,
      this.isStroked = false,
      this.isShowRightIcon = false,
      this.iconData,
      this.radius = 4.0,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.fromLTRB(10, 4, 12, 4),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: globalText(btnTxt, context,
                  textColor: isStroked! ? Colors.teal : Colors.white,
                  isCentered: true,
                  textAllCaps: false,
                  fontSize: fontSize!),
            ),
            isShowRightIcon! ? Icon(iconData,color: Colors.white) : const SizedBox.shrink()
          ],
        ),
        decoration: isStroked!
            ? boxDecoration(bgColor: Colors.transparent, borderColor: Colors.teal)
            : boxDecoration(bgColor: backgroundColor, radius: radius!),
      ),
    );
  }
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color borderColor = Colors.transparent,
    Color? bgColor,
    Color? shadowColor = Colors.grey,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor ?? Colors.white,
    boxShadow: showShadow
        ? [BoxShadow(color: shadowColor!, offset: const Offset(0, 0), blurRadius: 15, spreadRadius: 3)]
        : [const BoxShadow(color: Colors.transparent)],
    border: Border.all(color: borderColor),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

Widget globalText(String? text, BuildContext context,
    {double fontSize = 14,
    Color? textColor,
    var fontFamily,
    var isCentered = false,
    var maxLine = 1,
    var latterSpacing = 0.5,
    bool textAllCaps = false,
    var isLongText = false,
    bool lineThrough = false}) {
  return Text(
    textAllCaps ? text!.toUpperCase() : text!,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        fontSize: fontSize,
        color: textColor ?? Colors.teal,
        height: 1.5,
        letterSpacing: latterSpacing,
        decoration: lineThrough ? TextDecoration.lineThrough : TextDecoration.none),
  );
}

Widget backButton(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).pop();
    },
    child: Container(margin: const EdgeInsets.only(right: 10), child: Image.asset(ImagesModel.backIcon, width: 20, height: 20)),
  );
}
