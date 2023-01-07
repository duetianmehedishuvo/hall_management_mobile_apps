
import 'package:duetstahall/helper/age_helper.dart';
import 'package:duetstahall/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String getDate(String date, BuildContext context) {
  String createTime = '';
  DateTime time = DateTime.parse(date);

  AgeDuration age = Age.dateDifference(fromDate: time, toDate: DateTime.now(), includeToDate: false);
  int hourCompare = DateTime.now().hour - time.hour;
  int minuteCompare = DateTime.now().minute - time.minute;
  createTime = age.years > 0
      ? "${age.years} ${LocaleKeys.ye_ago.tr()}"
      : age.months > 0
          ? "${age.months} ${LocaleKeys.mo_ago.tr()}"
          : age.days > 0
              ? "${age.days} ${LocaleKeys.da_ago.tr()}"
              : hourCompare > 0
                  ? "$hourCompare ${LocaleKeys.ho_ago.tr()}"
                  : "$minuteCompare ${LocaleKeys.mi_ago.tr()}";

  return createTime;
}

// String convertPriceRetString(double price, String sym) {
//   return '${removeDecimalZeroFormat(price)} ${sym}';
// }

// String removeDecimalZeroFormat(double n) {
//   var formatter = n.truncateToDouble() == n ? NumberFormat('###,###,###') : NumberFormat('###,###,###.00');
//   return formatter.format(n);
// }
//
// String numberFormat(int n) {
//   var formatter = n.truncateToDouble() == n ? NumberFormat('#,##,###') : NumberFormat('#,##,###');
//   return formatter.format(n);
// }

bool isNumeric(String s) {
  if (s.isEmpty) {
    return false;
  }
  return double.tryParse(s) != null;
}
