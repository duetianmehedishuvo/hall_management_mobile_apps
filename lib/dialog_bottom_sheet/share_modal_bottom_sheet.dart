// import 'package:als_frontend/data/model/response/news_feed_model.dart';
// import 'package:als_frontend/provider/newsfeed_provider.dart';
// import 'package:als_frontend/provider/post_provider.dart';
// import 'package:als_frontend/util/theme/app_colors.dart';
// import 'package:als_frontend/widgets/custom_button.dart';
// import 'package:als_frontend/widgets/custom_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// void shareBottomSheet(BuildContext context, String url, NewsFeedModel newsfeedData) {
//   TextEditingController shareController = TextEditingController();
//
//   showModalBottomSheet<void>(
//     enableDrag: true,
//     isScrollControlled: true,
//     context: context,
//     builder: (BuildContext context) {
//       return Card(
//         color: Colors.white,
//         child: Consumer2<PostProvider, NewsFeedProvider>(
//           builder: (context, postProvider, newsfeedProvider, child) => SizedBox(
//             height: MediaQuery.of(context).size.height / 2 + MediaQuery.of(context).viewInsets.bottom,
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                   child: CustomTextField(
//                     hintText: "What's on your mind?.....",
//                     maxLines: null,
//                     fillColor: Colors.white,
//                     borderRadius: 0,
//                     verticalSize: 30,
//                     isCancelShadow: true,
//                     controller: shareController,
//                     inputAction: TextInputAction.done,
//                   ),
//                 ),
//                 postProvider.isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : CustomButton(
//                         btnTxt: 'share now',
//                         onTap: () {
//                           postProvider.sharePost(url, shareController.text, newsfeedData).then((value) {
//                             if (value.status!) {
//                               newsfeedProvider.addPostOnTimeLine(value.newsFeedData!);
//                             }
//                             Navigator.of(context).pop();
//                             shareController.text = '';
//                           });
//                         },
//                         backgroundColor: AppColors.feedback,
//                         textWhiteColor: true,
//                       ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
