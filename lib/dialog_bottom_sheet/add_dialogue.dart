// import 'package:als_frontend/data/model/response/news_feed_model.dart';
// import 'package:als_frontend/provider/post_provider.dart';
// import 'package:als_frontend/util/image.dart';
// import 'package:als_frontend/widgets/custom_button.dart';
// import 'package:als_frontend/widgets/custom_inkwell_btn.dart';
// import 'package:als_frontend/widgets/custom_text.dart';
// import 'package:als_frontend/widgets/custom_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
//
// class AddDialogue extends StatelessWidget {
//   final NewsFeedModel newsFeedData;
//
//   AddDialogue(this.newsFeedData, {Key? key}) : super(key: key);
//   final TextEditingController reportController = TextEditingController();
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
//                         title: 'Are you sure want to Report this post?',
//                         fontSize: 13,
//                         color: Colors.black,
//                         maxLines: 2,
//                         textAlign: TextAlign.center,
//                       ),
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
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: CustomTextField(
//                   hintText: 'Write here report reason...',
//                   fillColor: Colors.white,
//                   controller: reportController,
//                   inputAction: TextInputAction.done,
//                   borderRadius: 8,
//                   verticalSize: 13,
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
//                               backgroundColor: Colors.black,
//                               textWhiteColor: true,
//                               fontSize: 17,
//                             ),
//                           ),
//                           //Space
//                           const SizedBox(width: 5),
//                           Expanded(
//                             child: CustomButton(
//                               onTap: () {
//                                 FocusScope.of(context).unfocus();
//                                 if (reportController.text.isEmpty) {
//                                   Fluttertoast.showToast(msg: "Please Write Somethings", backgroundColor: Colors.red);
//                                 } else {
//                                   bool isFromGroup = newsFeedData.postType == 'group';
//                                   bool isFromPage = newsFeedData.postType == 'page';
//                                   postProvider
//                                       .reportPost(reportController.text.isEmpty ? "report post" : reportController.text, newsFeedData.id! as int,
//                                           isFromGroup: isFromGroup, isFromPage: isFromPage)
//                                       .then((value) {
//                                     if (value) {
//                                       reportController.clear();
//                                       Navigator.pop(context);
//                                     } else {
//                                       Navigator.pop(context);
//                                     }
//                                   });
//                                 }
//                               },
//                               btnTxt: 'Yes',
//                               fontSize: 17,
//                               backgroundColor: Colors.green,
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
