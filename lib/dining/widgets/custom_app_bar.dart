import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? isBackButtonExist;
  final Function? onBackPressed;
  final Function? onRefreshPressed;
  final double? appBarSize;
  final bool? isHomeScreen;
  final double borderRadius;
  final bool isRefreshEnable;
  final bool isRefreshEnable2;
  final bool isOpenCommunity;

  const CustomAppBar(
      {Key? key,
      required this.title,
      this.isBackButtonExist = true,
      this.isRefreshEnable = false,
      this.isOpenCommunity = false,
      this.isRefreshEnable2 = false,
      this.onBackPressed,
      this.onRefreshPressed,
      this.appBarSize = 85,
      this.borderRadius = 20,
      this.isHomeScreen = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, appBarSize!),
      child: Container(
        height: appBarSize,
        padding: const EdgeInsets.only(top: 30),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppColors.primaryColorLight,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(borderRadius), bottomRight: Radius.circular(borderRadius))),
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isBackButtonExist!
                    ? IconButton(
                        icon: Image.asset(ImagesModel.backIcon, width: 20, height: 20),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Provider.of<AuthProvider>(context, listen: false).getUserInfo(isFirstTime: false);
                        },
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: !isBackButtonExist! ? 30.0 : 15, top: !isBackButtonExist! ? 10.0 : 0),
                      child: Text(title!,
                          style: const TextStyle(fontSize: 18, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ),
                //
                isRefreshEnable
                    ? InkWell(
                        onTap: () {
                          Provider.of<StudentProvider>(context, listen: false).initializeAllStudent();
                        },
                        child: const Icon(Icons.refresh, color: Colors.white),
                      )
                    : isRefreshEnable2
                        ? InkWell(
                            onTap: () {
                              onRefreshPressed!();
                            },
                            child: const Icon(Icons.refresh, color: Colors.white),
                          )
                        : isOpenCommunity
                        ? InkWell(
                            onTap: () {
                              // onRefreshPressed!();
                            },
                            child: Row(
                              children: [
                                Text('My Post',style: robotoStyle500Medium.copyWith(color: Colors.white)),
                                spaceWeight5,
                                Icon(Icons.info, color: Colors.white,size: 18)
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                const SizedBox(width: 10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, appBarSize!);
}
