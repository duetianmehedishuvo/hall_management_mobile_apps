import 'package:duetstahall/data/model/response/community_model.dart';
import 'package:duetstahall/dialog_bottom_sheet/add_dialogue.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/community_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/student/community/community_details_screen.dart';
import 'package:duetstahall/view/screens/student/students/student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCommunityScreen extends StatefulWidget {
  const MyCommunityScreen({Key? key}) : super(key: key);

  @override
  State<MyCommunityScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<MyCommunityScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CommunityProvider>(context, listen: false).getAllCommunity(isAllPost: false);
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange &&
          Provider.of<CommunityProvider>(context, listen: false).hasNextData) {
        Provider.of<CommunityProvider>(context, listen: false).updateAllCommunity(isAllPost: false);
      }
    });
  }

  Future<void> _refresh(BuildContext context) async {
    Provider.of<CommunityProvider>(context, listen: false).getAllCommunity(isFirstTime: false, isAllPost: false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _refresh(context);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'My Community Posts', borderRadius: 0),

          body: Consumer<CommunityProvider>(
            builder: (context, communityProvider, child) => communityProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: controller,
                          itemCount: communityProvider.communityList.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          itemBuilder: (context, index) {
                            CommunityModel c = communityProvider.communityList[index];
                            return InkWell(
                              onTap: () {
                                communityProvider.changeCommunityID(c.id as int);
                                Helper.toScreen(CommunityDetailsScreen(c));
                              },
                              child: Container(
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
                                          Expanded(child: Text(c.name!, style: robotoStyle400Regular.copyWith(color: Colors.black.withOpacity(.5)))),
                                          Text(' | ', style: robotoStyle400Regular.copyWith(fontSize: 15, color: Colors.black.withOpacity(.5))),
                                          Expanded(child: Text(c.department!, style: robotoStyle400Regular.copyWith(color: Colors.black.withOpacity(.5)))),
                                          Text(' | ', style: robotoStyle400Regular.copyWith(fontSize: 15, color: Colors.black.withOpacity(.5))),
                                          Expanded(
                                              child: Text(c.studentId!.toString(),
                                                  style: robotoStyle400Regular.copyWith(color: Colors.black.withOpacity(.5)))),
                                        ],
                                      ),
                                    ),
                                    spaceHeight5,
                                    Text(c.details!,
                                        style: robotoStyle500Medium.copyWith(fontSize: 15, color: Colors.black),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis),
                                    Container(
                                        height: 1, width: screenWeight(), color: Colors.grey.withOpacity(.2), margin: EdgeInsets.symmetric(vertical: 4)),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text('${c.commentCount!} Comment${c.commentCount! > 1 ? 's' : ''}',
                                                style: robotoStyle400Regular.copyWith(color: Colors.black.withOpacity(.5)))),
                                        Text(DateConverter.localDateToString1(c.updatedAt!),
                                            style: robotoStyle400Regular.copyWith(fontSize: 13, color: Colors.black.withOpacity(.5))),
                                      ],
                                    ),
                                  ],
                                ),
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
