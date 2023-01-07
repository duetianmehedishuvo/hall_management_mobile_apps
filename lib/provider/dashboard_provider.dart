import 'package:flutter/foundation.dart';

class DashboardProvider with ChangeNotifier {
  int selectIndex = 0;

  changeSelectIndex(int value) {
    selectIndex = value;
    notifyListeners();
  }

  int backButtonPressCount = 0;

  resetBackButtonPress() {
    backButtonPressCount = 0;
    notifyListeners();
  }

  incrementBackButtonPressCount() {
    backButtonPressCount++;
    notifyListeners();
  }
}
