import 'package:duetstahall/data/model/response/hall_fee_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/hall_fee_provider.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/payment/add_balance_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HallFeeDetailsScreen extends StatefulWidget {
  final HallFeeModel hallFeeModel;

  const HallFeeDetailsScreen(this.hallFeeModel, {Key? key}) : super(key: key);

  @override
  State<HallFeeDetailsScreen> createState() => _HallFeeDetailsScreenState();
}

class _HallFeeDetailsScreenState extends State<HallFeeDetailsScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<HallFeeProvider>(context, listen: false).getUserAllSubHallFeeByID(widget.hallFeeModel.id as int);
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange &&
          Provider.of<HallFeeProvider>(context, listen: false).hasNextData2) {
        Provider.of<HallFeeProvider>(context, listen: false).updateUserAllSubHallFeeByID(widget.hallFeeModel.id as int);
      }
    });
  }

  Future<void> _refresh(BuildContext context) async {
    Provider.of<HallFeeProvider>(context, listen: false).getUserAllHallFeeByID(isFirstTime: false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _refresh(context);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Hall Fee Details', borderRadius: 0),
          body: Consumer<HallFeeProvider>(
            builder: (context, hallFeeProvider, child) => hallFeeProvider.isLoading2
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            singleWidget('Fee Added Time: ', DateConverter.localDateToString(widget.hallFeeModel.createdAt.toString())),
                            const Divider(),
                            singleWidget('Assign amount: ', widget.hallFeeModel.amount.toString() + AppConstant.currencySymbolTaka),
                            const Divider(),
                            singleWidget('Fine amount: ', widget.hallFeeModel.fine.toString() + AppConstant.currencySymbolTaka),
                            const Divider(),
                            singleWidget('Total Due amount: ', "= ${widget.hallFeeModel.due}${AppConstant.currencySymbolTaka}"),
                            const Divider(),
                            Text('Purpose:', style: robotoStyle700Bold.copyWith(color: Colors.black)),
                            const SizedBox(height: 7),
                            Text(widget.hallFeeModel.purpose!, style: robotoStyle500Medium),
                            const Divider(),
                            widget.hallFeeModel.due as int > 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Helper.toScreen(AddBalanceScreen(
                                                isPayBalance: true,
                                                amount: int.parse(widget.hallFeeModel.due.toString()),
                                                id: widget.hallFeeModel.id as int));
                                          },
                                          child: Container(
                                            decoration:
                                                BoxDecoration(color: AppColors.primaryColorLight, borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                            child: Text('Pay Now', style: robotoStyle600SemiBold.copyWith(color: Colors.white)),
                                          )),
                                    ],
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                      hallFeeProvider.hallFeeSubList.isEmpty
                          ? Center(
                              child: Container(
                                  height: 100,
                                  alignment: Alignment.center,
                                  child: Text('There has no child for due transaction', style: robotoStyle600SemiBold.copyWith())))
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: SingleChildScrollView(
                                child: DataTable(
                                  // showBottomBorder: true,
                                  dataRowColor: MaterialStateProperty.all(Colors.white),
                                  headingRowColor: MaterialStateProperty.all(AppColors.primaryColorLight),
                                  headingRowHeight: 40.0,
                                  dataRowHeight: 40.0,
                                  decoration: const BoxDecoration(color: Colors.grey),
                                  sortColumnIndex: 0,
                                  sortAscending: true,
                                  headingTextStyle: robotoStyle700Bold.copyWith(color: Colors.white, fontSize: 14),
                                  dataTextStyle: robotoStyle400Regular.copyWith(color: Colors.white, fontSize: 12),
                                  columnSpacing: 20,
                                  // horizontalMargin: 1,
                                  columns: [
                                    buildDataColumn('ID', 'represents if Index No.'),
                                    buildDataColumn('Amount', 'represents Transaction ID.'),
                                    buildDataColumn('Time', 'represents Transaction Time'),
                                    buildDataColumn('Purpose', 'represents Transaction Purpose'),
                                  ],
                                  rows: List.generate(
                                      hallFeeProvider.hallFeeSubList.length,
                                      (index) => DataRow(
                                              color: MaterialStateColor.resolveWith((states) {
                                                return Colors.grey.withOpacity(.2); //make tha magic!
                                              }),
                                              cells: [
                                                DataCell(Center(child: Text('${index + 1}'))),
                                                DataCell(Center(child: Text("${hallFeeProvider.hallFeeSubList[index].money}৳"))),
                                                DataCell(Center(
                                                    child: Text(DateConverter.localDateToString1(
                                                        hallFeeProvider.hallFeeSubList[index].createdDate.toString())))),
                                                DataCell(Text(hallFeeProvider.hallFeeSubList[index].purpose!)),
                                              ])),
                                ),
                              ),
                            ),
                      hallFeeProvider.isBottomLoading2
                          ? const Center(child: CircularProgressIndicator())
                          : hallFeeProvider.hasNextData2
                              ? InkWell(
                                  onTap: () {
                                    hallFeeProvider.updateUserAllSubHallFeeByID(widget.hallFeeModel.id as int);
                                  },
                                  child: Container(
                                    height: 30,
                                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(border: Border.all(color: colorText), borderRadius: BorderRadius.circular(22)),
                                    child: Text('Load more Data', style: robotoStyle500Medium.copyWith(color: colorText)),
                                  ),
                                )
                              : const SizedBox.shrink(),
                    ],
                  ),
          )),
    );
  }

  Widget singleWidget(String title, String title2) {
    return Row(
      children: [
        Expanded(child: Text(title, style: robotoStyle700Bold.copyWith(color: Colors.black))),
        Container(width: 2, color: Colors.grey.withOpacity(.3), height: 20, margin: const EdgeInsets.only(right: 10)),
        Expanded(child: Text(title2, style: robotoStyle500Medium)),
      ],
    );
  }

  void route() {
    Helper.toScreen(Container());
  }

  DataColumn buildDataColumn(String title, String tooltips) =>
      DataColumn(label: Expanded(child: Center(child: Text(title, textAlign: TextAlign.center))), tooltip: tooltips);
}
