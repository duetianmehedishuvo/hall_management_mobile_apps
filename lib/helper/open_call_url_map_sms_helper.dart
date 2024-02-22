import 'package:url_launcher/url_launcher.dart';

openFeedbackAppOnPlayStore() async {
  String url = 'https://play.google.com/store/apps/details?id=com.als.feedback';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
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

Future<void> openNewLink(String link) async {
  if (!await launchUrl(Uri.parse(link))) {
    throw Exception('Could not launch $link');
  }
}
