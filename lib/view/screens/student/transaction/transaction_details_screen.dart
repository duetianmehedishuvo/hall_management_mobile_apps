import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionDetailsScreen> createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<StudentProvider>(context, listen: false).callForGetUserAllTransaction();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange &&
          Provider.of<StudentProvider>(context, listen: false).hasNextData) {
        Provider.of<StudentProvider>(context, listen: false).updateUserTransactionListNo();
      }
    });
  }

  Future<void> _refresh(BuildContext context) async {
    Provider.of<StudentProvider>(context, listen: false).callForGetUserAllTransaction(isFirstTime: false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _refresh(context);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'My All Statements', borderRadius: 0),
          body: Consumer<StudentProvider>(
            builder: (context, studentProvider, child) => studentProvider.isLoading
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
                              buildDataColumn('Transaction ID', 'represents Transaction ID.'),
                              buildDataColumn('Amount', 'represents Balance Amount.'),
                              buildDataColumn('Time', 'represents Transaction Time'),
                              buildDataColumn('Purpose', 'represents Transaction Purpose'),
                            ],
                            rows: List.generate(
                                studentProvider.transactionList.length,
                                (index) => DataRow(
                                        color: MaterialStateColor.resolveWith((states) {
                                          return studentProvider.transactionList[index].isIn != 0
                                              ? Colors.green
                                              : Colors.red; //make tha magic!
                                        }),
                                        cells: [
                                          DataCell(Center(child: Text('${index + 1}'))),
                                          DataCell(Center(child: Text(studentProvider.transactionList[index].transactionID.toString()))),
                                          DataCell(Center(child: Text(studentProvider.transactionList[index].amount.toString()))),
                                          DataCell(Center(
                                            child: Text(DateConverter.localDateToString(
                                                studentProvider.transactionList[index].createdAt.toString())),
                                          )),
                                          DataCell(Text(studentProvider.transactionList[index].purpose!)),
                                        ])),
                          ),
                        ),
                      ),
                      studentProvider.isBottomLoading
                          ? const Center(child: CircularProgressIndicator())
                          : studentProvider.hasNextData
                              ? InkWell(
                                  onTap: () {
                                    studentProvider.updateUserTransactionListNo();
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

  DataColumn buildDataColumn(String title, String tooltips) =>
      DataColumn(label: Expanded(child: Center(child: Text(title, textAlign: TextAlign.center))), tooltip: tooltips);
}
