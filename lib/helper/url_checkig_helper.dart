

import 'package:flutter/cupertino.dart';

bool hasValidUrl(String value) {
  String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return false;
  }
  else if (regExp.hasMatch(value)) {
    return true;
  }
  return false;
}

bool isValidUrl(String value){
  if(Uri.parse(value).host.isNotEmpty){
    return false;
  }
  return true;
}
List<String> extractdescription(String text){
  final urlRegExp = RegExp(
      r"((https?:www\.)|(https?://)|(www\.))[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(/[-a-zA-Z0-9()@:%_+.~#?&/=]*)?");
  final urlMatches = urlRegExp.allMatches(text);
  List<String> urls = urlMatches.map(
          (urlMatch) => text.substring(urlMatch.start, urlMatch.end))
      .toList();
  for (var x in urls) {
    debugPrint(x);
  }
  return urls;
}

String removeAllUrl(String text){
  final newString = text.replaceAll(RegExp(r"(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?"), "");
  return newString;
}