import 'package:duetstahall/data/model/response/commend_model.dart';
import 'package:duetstahall/data/model/response/community_model.dart';
import 'package:duetstahall/dialog_bottom_sheet/add_dialogue.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/community_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/student/students/student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityDetailsScreen extends StatefulWidget {
  final CommunityModel communityModel;

  const CommunityDetailsScreen(this.communityModel, {super.key});

  @override
  State<CommunityDetailsScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<CommunityDetailsScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CommunityProvider>(context, listen: false).getAllCommend();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange &&
          Provider.of<CommunityProvider>(context, listen: false).hasNextDataCommend) {
        Provider.of<CommunityProvider>(context, listen: false).updateAllCommend();
      }
    });
  }

  Future<void> _refresh(BuildContext context) async {
    Provider.of<CommunityProvider>(context, listen: false).getAllCommend(isFirstTime: false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _refresh(context);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Details', borderRadius: 0),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddDialogue(isPost: false, id: widget.communityModel.id as int);
                  },
                );
              },
              backgroundColor: colorPrimaryLight,
              child: const Icon(Icons.add, color: Colors.white)),
          body: Consumer<CommunityProvider>(
            builder: (context, communityProvider, child) => communityProvider.isLoadingCommend
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                        ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Helper.toScreen(StudentDetailsScreen(widget.communityModel.studentId.toString()));
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child:
                                          Text(widget.communityModel.name!, style: robotoStyle400Regular.copyWith(color: Colors.black.withOpacity(.5)))),
                                  Text(' | ', style: robotoStyle400Regular.copyWith(fontSize: 15, color: Colors.black.withOpacity(.5))),
                                  Expanded(
                                      child: Text(widget.communityModel.department!,
                                          style: robotoStyle400Regular.copyWith(color: Colors.black.withOpacity(.5)))),
                                  Text(' | ', style: robotoStyle400Regular.copyWith(fontSize: 15, color: Colors.black.withOpacity(.5))),
                                  Expanded(
                                      child: Text(widget.communityModel.studentId!.toString(),
                                          style: robotoStyle400Regular.copyWith(color: Colors.black.withOpacity(.5)))),
                                ],
                              ),
                            ),
                            spaceHeight5,
                            Text(widget.communityModel.details!,
                                style: robotoStyle500Medium.copyWith(fontSize: 15, color: Colors.black), maxLines: 3, overflow: TextOverflow.ellipsis),
                            Container(height: 1, width: screenWeight(), color: Colors.grey.withOpacity(.2), margin: EdgeInsets.symmetric(vertical: 4)),
                            Row(
                              children: [
                                Expanded(
                                    child: Text('${widget.communityModel.commentCount!} Comment${widget.communityModel.commentCount! > 1 ? 's' : ''}',
                                        style: robotoStyle400Regular.copyWith(color: Colors.black.withOpacity(.5)))),
                                Text(DateConverter.localDateToString1(widget.communityModel.updatedAt!),
                                    style: robotoStyle400Regular.copyWith(fontSize: 13, color: Colors.black.withOpacity(.5))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      communityProvider.commendList.isEmpty ? spaceZero : Text('ALL Comments', style: robotoStyle500Medium.copyWith(fontSize: 15)),
                      Expanded(
                        child: communityProvider.commendList.isEmpty
                            ? Text('No Data Found', style: robotoStyle500Medium)
                            : ListView.builder(
                                controller: controller,
                                itemCount: communityProvider.commendList.length,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                itemBuilder: (context, index) {
                                  CommendModel c = communityProvider.commendList[index];
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                                      BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                                    ]),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Helper.toScreen(StudentDetailsScreen(c.studentId.toString()));
                                          },
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(c.name!,
                                                      style: robotoStyle400Regular.copyWith(fontSize: 12, color: Colors.black.withOpacity(.5)))),
                                              Text(' | ', style: robotoStyle400Regular.copyWith(fontSize: 12, color: Colors.black.withOpacity(.5))),
                                              Expanded(
                                                  child: Text(c.studentId!.toString(),
                                                      style: robotoStyle400Regular.copyWith(fontSize: 10, color: Colors.black.withOpacity(.5)))),
                                              Text(' | ', style: robotoStyle400Regular.copyWith(fontSize: 12, color: Colors.black.withOpacity(.5))),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(DateConverter.localDateToString1(c.createdAt!),
                                                      style: robotoStyle400Regular.copyWith(fontSize: 12, color: Colors.black.withOpacity(.5)))),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            height: 1,
                                            width: screenWeight(),
                                            color: Colors.grey.withOpacity(.2),
                                            margin: EdgeInsets.symmetric(vertical: 4)),
                                        Text(c.comment!,
                                            style: robotoStyle500Medium.copyWith(fontSize: 15, color: Colors.black),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          )),
    );
  }
}
