// import 'package:duetstahall/data/model/response/news_feed_model.dart';
// import 'package:duetstahall/provider/group_provider.dart';
// import 'package:duetstahall/provider/page_provider.dart';
// import 'package:duetstahall/provider/post_provider.dart';
// import 'package:duetstahall/provider/profile_provider.dart';
// import 'package:duetstahall/util/image.dart';
// import 'package:duetstahall/widgets/custom_button.dart';
// import 'package:duetstahall/widgets/custom_inkwell_btn.dart';
// import 'package:duetstahall/widgets/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class DeleteDialogue extends StatelessWidget {
//   final NewsFeedModel newsFeedData;
//   final int index;
//
//   const DeleteDialogue(this.newsFeedData, this.index, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.symmetric(horizontal: 18),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       clipBehavior: Clip.hardEdge,
//       child: Container(
//         color: Colors.white,
//         child: Consumer<PostProvider>(
//           builder: (context, postProvider, child) => Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               //Space
//               const SizedBox(height: 10),
//               //f
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Image.asset(ImagesModel.logo, width: 30, height: 30),
//                     const Expanded(
//                       child: CustomText(
//                           title: 'Are you sure want to Delete this post?',
//                           fontSize: 13,
//                           color: Colors.black,
//                           maxLines: 2,
//                           textAlign: TextAlign.center),
//                     ),
//                     CustomInkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(Icons.clear, color: Theme.of(context).textTheme.headline1!.color!),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//
//               //NO YES
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 alignment: Alignment.center,
//                 child: postProvider.isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: CustomButton(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               btnTxt: 'No',
//                               backgroundColor: Colors.green,
//                               textWhiteColor: true,
//                               fontSize: 17,
//                               height: 35,
//                             ),
//                           ),
//                           //Space
//                           const SizedBox(width: 45),
//                           Expanded(
//                             child: CustomButton(
//                               onTap: () {
//                                 bool isFromGroup = newsFeedData.postType == 'group';
//                                 bool isFromPage = newsFeedData.postType == 'page';
//                                 bool isFromTimeline = newsFeedData.postType == 'timeline';
//                                 postProvider.deletePost(newsFeedData.commentUrl!).then((value) {
//                                   if (value) {
//                                     if (isFromGroup) {
//                                       Provider.of<GroupProvider>(context, listen: false).deleteNewsfeedData(index);
//                                     } else if (isFromPage) {
//                                       Provider.of<PageProvider>(context, listen: false).deleteNewsfeedData(index);
//                                     } else if (isFromTimeline) {
//                                       Provider.of<ProfileProvider>(context, listen: false).deleteNewsfeedData(index);
//                                     }
//                                     Navigator.pop(context);
//                                   } else {
//                                     Navigator.pop(context);
//                                   }
//                                 });
//                               },
//                               btnTxt: 'Yes',
//                               fontSize: 17,
//                               height: 35,
//                               backgroundColor: Colors.red,
//                               textWhiteColor: true,
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//               //Space
//               const SizedBox(height: 15),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
