import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/library_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/library/purched_all_book_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CheckCardScreen extends StatefulWidget {
  const CheckCardScreen({super.key});

  @override
  State<CheckCardScreen> createState() => _CheckCardScreenState();
}

class _CheckCardScreenState extends State<CheckCardScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LibraryProvider>(context, listen: false).checkCardIssue();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   Provider.of<LibraryProvider>(context, listen: false).changeCheckCardIssue();
  //   Timer(Duration(seconds: 2),(){
  //
  //   });
  //   super.dispose();
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        Provider.of<LibraryProvider>(context, listen: false).changeCheckCardIssue();
        if (didPop) {
          // If back navigation was allowed, do nothing.
          return;
        }

        // If it was not allowed, do this
        final NavigatorState navigator = Navigator.of(context);
        navigator.pop();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'All Book List', borderRadius: 0),
          body: Consumer<LibraryProvider>(
            builder: (context, libraryProvider, child) => libraryProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Lottie.asset('assets/animations/searching.json', width: screenWeight(), height: screenWeight(), fit: BoxFit.fill),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: screenWeight() / 14,
                        child: libraryProvider.cardID.isEmpty
                            ? spaceZero
                            : Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Helper.toScreen(PurchedAllBookHistoryScreen(isAdmin: true));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: kSecondaryColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
                                      child: Column(
                                        children: [
                                          Text('Student Found', style: robotoStyle600SemiBold.copyWith(color: Colors.black)),
                                          Text('Card-ID: ${libraryProvider.cardID}', style: robotoStyle600SemiBold.copyWith(color: Colors.white)),
                                          Text('Stu-ID: ${libraryProvider.studentID}',
                                              style: robotoStyle500Medium.copyWith(color: Colors.white, fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      )
                    ],
                  ),
          )),
    );
  }

// void route(HallFeeModel hallFeeModel, int index) {
//   Helper.toScreen(HallFeeDetailsScreen(hallFeeModel, isAdmin: widget.isAdmin, index: index));
// }
}
