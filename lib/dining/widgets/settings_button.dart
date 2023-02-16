import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  final String hintKey;
  final Widget? hintWidget;
  final Function() onClick;
  final bool hideDivider;
  final Color color;

  const SettingsButton(
      {Key? key,
      required this.icon,
      required this.labelKey,
      this.hintKey = "",
      required this.onClick,
      this.hideDivider = false,
      this.hintWidget,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(icon, size: 20, color: color),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(60))),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Text(labelKey, style: headline3.copyWith(fontSize: 13)),
                ],
              ),
              Row(
                children: <Widget>[
                  if (hintKey.isNotEmpty)
                    Container(
                      margin: const EdgeInsetsDirectional.only(end: 8),
                      child: Text(hintKey, style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.black.withOpacity(0.3))),
                    ),
                  if (hintWidget != null) hintWidget! else const Icon(Icons.arrow_forward_ios, size: 30),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
