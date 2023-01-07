// import 'package:als_frontend/data/model/response/news_feed_model.dart';
// import 'package:als_frontend/dialog_bottom_sheet/add_dialogue.dart';
// import 'package:als_frontend/dialog_bottom_sheet/delete_dialogue.dart';
// import 'package:als_frontend/provider/auth_provider.dart';
// import 'package:als_frontend/provider/post_provider.dart';
// import 'package:als_frontend/screens/posts/add_post_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// void moreMenuBottomSheet(BuildContext context, NewsFeedModel newsFeedData, int index,
//     {bool isFromProfile = false, bool isFromGroupScreen = false, bool isForPage = false, int groupPageID = 0}) {
//   String userID = Provider.of<AuthProvider>(context, listen: false).userID;
//   double height = 0;
//   if (userID == newsFeedData.author!.id.toString()) {
//     height = 120;
//   } else {
//     height = 70;
//   }
//
//   if (newsFeedData.postType == 'group') {
//     isFromGroupScreen = true;
//   } else if (newsFeedData.postType == 'page') {
//     isForPage = true;
//   }
//
//   showModalBottomSheet(
//       context: context,
//       isDismissible: true,
//       isScrollControlled: true,
//       constraints: const BoxConstraints(),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setModalState) {
//             return SizedBox(
//               height: height + 4,
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                 child: Column(
//                   children: <Widget>[
//                     Visibility(
//                       visible: height == 120,
//                       child: InkWell(
//                         borderRadius: BorderRadius.circular(15),
//                         onTap: () {
//                           Navigator.of(context).pop();
//                           Provider.of<PostProvider>(context, listen: false).clearImageVideo();
//                           Provider.of<PostProvider>(context, listen: false).initializeImageVideo(newsFeedData);
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (_) => AddPostScreen(Provider.of<AuthProvider>(context, listen: false).profileImage,
//                                   isFromGroupScreen: isFromGroupScreen,
//                                   groupPageID: groupPageID,
//                                   isForPage: isForPage,
//                                   isEditPost: true,
//                                   post: newsFeedData,
//                                   isFromProfileScreen: isFromProfile,
//                                   index: index)));
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(6.0),
//                           child: Row(
//                             children: const <Widget>[
//                               Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.edit)),
//                               Padding(padding: EdgeInsets.all(8.0), child: Text('Edit Post')),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: height == 120,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                           showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return DeleteDialogue(newsFeedData, index);
//                               });
//                         },
//                         borderRadius: BorderRadius.circular(15),
//                         child: Padding(
//                           padding: const EdgeInsets.all(6.0),
//                           child: Row(
//                             children: const <Widget>[
//                               Padding(padding: EdgeInsets.all(8.0), child: Icon(CupertinoIcons.delete)),
//                               Padding(padding: EdgeInsets.all(8.0), child: Text('Delete Post')),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: height != 120,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                           showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return AddDialogue(newsFeedData);
//                               });
//                         },
//                         borderRadius: BorderRadius.circular(15),
//                         child: Padding(
//                           padding: const EdgeInsets.all(6.0),
//                           child: Row(
//                             children: const <Widget>[
//                               Padding(padding: EdgeInsets.all(8.0), child: Icon(CupertinoIcons.asterisk_circle)),
//                               Padding(padding: EdgeInsets.all(8.0), child: Text('Report This Post')),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     //
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       });
// }
