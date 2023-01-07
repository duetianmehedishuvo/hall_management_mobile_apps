import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

openFeedbackMessengerApp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('token') ?? '');
  String url = 'feedback://chatting.com/$token';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

openFeedbackAppOnPlayStore() async {
  String url = 'https://play.google.com/store/apps/details?id=com.als.feedback';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

openNewEmail(String mail) async {
  final Uri params = Uri(scheme: 'mailto', path: mail, query: 'subject=Write your problems here...');
  if (await canLaunchUrl(params)) {
    await launchUrl(params);
  } else {
    throw 'Could not launch ${params.toString()}';
  }
}
openNewLink(String link) async{
  if (await canLaunchUrl(Uri.parse(link))) {
    await launchUrl(Uri.parse(link));
  } else {
    throw 'Could not launch $link';
  }
}

