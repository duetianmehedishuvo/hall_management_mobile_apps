import 'package:duetstahall/data/model/response/hall_fee_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/complain_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/hall_fee/hall_fee_details_screen.dart';
import 'package:duetstahall/view/screens/student/complain/add_complain_screen.dart';
import 'package:duetstahall/view/screens/student/complain/complain_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComplainScreen extends StatefulWidget {
  final bool isAdmin;

  const ComplainScreen({this.isAdmin = false, Key? key}) : super(key: key);

  @override
  State<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ComplainProvider>(context, listen: false).getAllComplain(isAdmin: widget.isAdmin);
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange &&
          Provider.of<ComplainProvider>(context, listen: false).hasNextData) {
        Provider.of<ComplainProvider>(context, listen: false).updateAllComplain(isAdmin: widget.isAdmin);
      }
    });
  }

  Future<void> _refresh(BuildContext context) async {
    Provider.of<ComplainProvider>(context, listen: false).getAllComplain(isFirstTime: false, isAdmin: widget.isAdmin);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _refresh(context);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Complain', borderRadius: 0),
          floatingActionButton: widget.isAdmin
              ? const SizedBox.shrink()
              : FloatingActionButton(
                  onPressed: () {
                    Helper.toScreen(AddComplainScreen());
                  },
                  backgroundColor: colorPrimaryLight,
                  child: const Icon(Icons.add)),
          body: Consumer<ComplainProvider>(
            builder: (context, complainProvider, child) => complainProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const CircleAvatar(backgroundColor: Colors.green, radius: 10),
                                  Text('  Solved', style: robotoStyle600SemiBold)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const CircleAvatar(backgroundColor: Colors.grey, radius: 10),
                                  Text('  Assign', style: robotoStyle600SemiBold)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: controller,
                          itemCount: complainProvider.allComplainList.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Helper.toScreen(ComplainDetailsScreen(
                                    complainModel: complainProvider.allComplainList[index], index: index, isAdmin: widget.isAdmin));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: complainProvider.allComplainList[index].reply!.isEmpty ? Colors.grey : Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(.2),
                                          blurRadius: 10.0,
                                          spreadRadius: 3.0,
                                          offset: const Offset(0.0, 0.0))
                                    ]),
                                child: Text(complainProvider.allComplainList[index].subject!,
                                    style: robotoStyle400Regular.copyWith(fontSize: 15, color: Colors.white)),
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

  void route(HallFeeModel hallFeeModel, int index) {
    Helper.toScreen(HallFeeDetailsScreen(hallFeeModel, isAdmin: widget.isAdmin, index: index));
  }

  DataColumn buildDataColumn(String title, String tooltips) =>
      DataColumn(label: Expanded(child: Center(child: Text(title, textAlign: TextAlign.center))), tooltip: tooltips);
}
