import 'package:duetstahall/util/dimensions.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/string_resources.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';

class NoInternetOrDataScreen extends StatelessWidget {
  final bool isNoInternet;
  final bool isNoSearchData;

  const NoInternetOrDataScreen({Key? key, required this.isNoInternet, this.isNoSearchData = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColorDark,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(isNoInternet ? ImagesModel.no_internet : ImagesModel.no_data, width: 150, height: 150),
              Text(isNoInternet ? Strings.OPPS : Strings.sorry,
                  style: headline4.copyWith(
                    fontSize: 30,
                    color: isNoInternet ? Colors.black : AppColors.primaryColorLight,
                  )),
              const SizedBox(height: 5),
              Text(
                isNoInternet
                    ? 'No internet connection'
                    : isNoSearchData
                        ? "No Search Data Found"
                        : 'No data found',
                textAlign: TextAlign.center,
                style: headline4,
              ),
              const SizedBox(height: 40),
              isNoInternet
                  ? Container(
                      height: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.primaryColorLight),
                      child: MaterialButton(
                        onPressed: () {},
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(Strings.RETRY,
                              style: headline4.copyWith(color: AppColors.whiteColorDark, fontSize:20)),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
