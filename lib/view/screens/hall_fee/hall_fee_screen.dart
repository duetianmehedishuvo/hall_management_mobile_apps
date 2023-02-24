import 'package:duetstahall/data/model/response/hall_fee_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/hall_fee_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/hall_fee/hall_fee_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HallFeeScreen extends StatefulWidget {
  const HallFeeScreen({Key? key}) : super(key: key);

  @override
  State<HallFeeScreen> createState() => _HallFeeScreenState();
}

class _HallFeeScreenState extends State<HallFeeScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<HallFeeProvider>(context, listen: false).getUserAllHallFeeByID();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange &&
          Provider.of<HallFeeProvider>(context, listen: false).hasNextData) {
        Provider.of<HallFeeProvider>(context, listen: false).updateUserAllHallFeeByID();
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
          appBar: const CustomAppBar(title: 'Hall Fee Statements', borderRadius: 0),
          body: Consumer<HallFeeProvider>(
            builder: (context, hallFeeProvider, child) => hallFeeProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    children: [
                      SingleChildScrollView(
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
                              buildDataColumn('Due', 'represents Balance Amount.'),
                              buildDataColumn('Fine', 'represents Transaction Time'),
                              buildDataColumn('Time', 'represents Transaction Time'),
                              buildDataColumn('Purpose', 'represents Transaction Purpose'),
                            ],
                            rows: List.generate(
                                hallFeeProvider.hallFeeList.length,
                                (index) => DataRow(
                                        color: MaterialStateColor.resolveWith((states) {
                                          return hallFeeProvider.hallFeeList[index].due == 0 ? Colors.green : Colors.red; //make tha magic!
                                        }),
                                        cells: [
                                          DataCell(Center(child: Text('${index + 1}')), onTap: (){
                                            route(hallFeeProvider.hallFeeList[index]);
                                          }),
                                          DataCell(Center(child: Text("${hallFeeProvider.hallFeeList[index].amount}৳")), onTap: (){
                                            route(hallFeeProvider.hallFeeList[index]);
                                          }),
                                          DataCell(Center(child: Text("${hallFeeProvider.hallFeeList[index].due}৳")), onTap: (){
                                            route(hallFeeProvider.hallFeeList[index]);
                                          }),
                                          DataCell(Center(child: Text("${hallFeeProvider.hallFeeList[index].fine}৳")), onTap: (){
                                            route(hallFeeProvider.hallFeeList[index]);
                                          }),
                                          DataCell(
                                              Center(
                                                  child: Text(DateConverter.localDateToString(
                                                      hallFeeProvider.hallFeeList[index].createdAt.toString()))),
                                              onTap: (){
                                                route(hallFeeProvider.hallFeeList[index]);
                                              }),
                                          DataCell(Text(hallFeeProvider.hallFeeList[index].purpose!), onTap: (){
                                            route(hallFeeProvider.hallFeeList[index]);
                                          }),
                                        ])),
                          ),
                        ),
                      ),
                      hallFeeProvider.isBottomLoading
                          ? const Center(child: CircularProgressIndicator())
                          : hallFeeProvider.hasNextData
                              ? InkWell(
                                  onTap: () {
                                    hallFeeProvider.updateUserAllHallFeeByID();
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

  void route(HallFeeModel hallFeeModel) {
    Helper.toScreen(HallFeeDetailsScreen(hallFeeModel));
  }

  DataColumn buildDataColumn(String title, String tooltips) =>
      DataColumn(label: Expanded(child: Center(child: Text(title, textAlign: TextAlign.center))), tooltip: tooltips);
}
