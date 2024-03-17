import 'package:duetstahall/helper/open_call_url_map_sms_helper.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/library_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/auth/signin_screen.dart';
import 'package:duetstahall/view/screens/library/add_book_screen.dart';
import 'package:duetstahall/view/screens/library/all_book_screen.dart';
import 'package:duetstahall/view/screens/library/check_card_screen.dart';
import 'package:duetstahall/view/screens/library/purched_all_book_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).getUserInfo();
    Provider.of<LibraryProvider>(context, listen: false).changeLoadingFalse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(checkIsAdmin ? 'Administration Central Library' : 'Central Library'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryColorLight,
        actions: [
          !checkIsAdmin
              ? spaceZero
              : IconButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout().then((value) {
                      if (value == true) {
                        Helper.toRemoveUntilScreen(const LoginScreen());
                      }
                    });
                  },
                  icon: const Icon(Icons.logout)),
        ],
      ),
      body: Consumer<LibraryProvider>(
        builder: (context, libraryProvider, child) => ModalProgressHUD(
          inAsyncCall: libraryProvider.isLoading,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  'DUET Central Library aims to be a world class knowledge resource center and aims to provide new services and a wider collection of items for the library users among the faculty member, students and researchers. Using latest technological developments of the 21st century. The development, organization and maintenance of archives in multiple locations; access to world class resources, Personalized assistance in the use of library and information resources; and instruction on research strategies and tools have made this one of the richest libraries in the country.',
                  style: robotoStyle400Regular.copyWith(fontSize: 13),
                  textAlign: TextAlign.justify,
                ),
              ),
              spaceHeight5,
              spaceHeight5,
              !checkIsAdmin ? spaceZero : buttonWidget(Icons.add_circle, 'Add Book', const AddBookScreen()),
              buttonWidget(Icons.library_books, 'All Books', AllBookScreen(isAdmin: checkIsAdmin)),
              !checkIsAdmin
                  ? spaceZero
                  : buttonWidget(Icons.book_sharp, 'Issue Books', const AllBookScreen(isAdmin: true), onTap: () {
                      libraryProvider.deleteAllCard().then((value) {
                        if (value == true) {
                          Helper.toScreen(CheckCardScreen());
                        }
                      });
                    }),
              checkIsAdmin
                  ? spaceZero
                  : buttonWidget(Icons.library_add_rounded, 'My Renew and Return Book List', PurchedAllBookHistoryScreen(isAdmin: false)),
              buttonWidget(Icons.notifications_active, 'Notices', Container(),
                  url: 'http://103.133.35.62:8081/cgi-bin/koha/opac-news-rss.pl?branchcode=MNL'),
              buttonWidget(Icons.report_sharp, 'DUET Institutional Repository', Container(), url: 'http://103.133.35.64:8080/xmlui/'),
              buttonWidget(Icons.report_sharp, 'UGC Digital Library', Container(), url: 'http://udl-ugc.gov.bd/'),
              buttonWidget(Icons.report_sharp, 'Bansdoc Library', Container(), url: 'https://bansdoc.gov.bd/'),
              buttonWidget(Icons.access_time, 'Library Hour', Container(), url: 'https://www.duet.ac.bd/office/central-library'),
              buttonWidget(Icons.people, 'Peoples', Container(), url: 'https://www.duet.ac.bd/office/central-library/employee-information'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonWidget(IconData iconData, String title, Widget widget, {String? url, Function? onTap}) {
    return InkWell(
      onTap: () {
        if (url == null && onTap == null) {
          Helper.toScreen(widget);
        } else if (onTap != null) {
          onTap();
        } else {
          openNewLink(url!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, spreadRadius: 1, offset: const Offset(0, 0))],
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [Icon(iconData, color: colorPrimaryLight), spaceWeight5, Text(title, style: robotoStyle500Medium.copyWith(fontSize: 15))],
        ),
      ),
    );
  }
}
