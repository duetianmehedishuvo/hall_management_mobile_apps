import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/config_model.dart';
import 'package:duetstahall/data/repository/settings_repo.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  final SettingsRepo settingsRepo;

  SettingsProvider({required this.settingsRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool hasAvailableGuestMeal = false;

  changeGuestAccess(bool value, {bool isFirstTime = false}) {
    hasAvailableGuestMeal = value;
    if (!isFirstTime) {
      notifyListeners();
      changeGuestMealAddedStatus();
    }
  }

  ConfigModel configModel = ConfigModel();

  getConfigData() async {
    _isLoading = true;
    configModel = ConfigModel();
    ApiResponse apiResponse = await settingsRepo.getConfig();
    _isLoading = false;
    if (apiResponse.response.statusCode == 200) {
      configModel = ConfigModel.fromJson(apiResponse.response.data);
      hasAvailableGuestMeal = configModel.isAvaibleGuestMeal == 0 ? false : true;
    } else {
      String errorMessage = apiResponse.error.toString();
      showMessage(errorMessage, isError: true);
    }
    notifyListeners();
  }

  changeGuestMealAddedStatus() async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await settingsRepo.changeGuestMealAddedStatus(hasAvailableGuestMeal == true ? 1 : 0);
    _isLoading = false;
    if (apiResponse.response.statusCode == 200) {
      showMessage(apiResponse.response.data['message'], isError: false);
      configModel.isAvaibleGuestMeal = hasAvailableGuestMeal == true ? 1 : 0;
    } else {
      String errorMessage = apiResponse.error.toString();
      showMessage(errorMessage, isError: true);
    }
    notifyListeners();
  }

  updateOfflineTakaCollectTime(String text) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await settingsRepo.updateOfflineTakaCollectTime(text);
    _isLoading = false;
    if (apiResponse.response.statusCode == 200) {
      showMessage(apiResponse.response.data['message'], isError: false);
      configModel.offlineTakaLoadTime = text;
      hasActiveOther = false;
    } else {
      String errorMessage = apiResponse.error.toString();
      showMessage(errorMessage, isError: true);
    }
    notifyListeners();
  }

  updateMealRate(int amount, bool isGuestMode) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await settingsRepo.updateMealRate(amount, isGuestMode);
    _isLoading = false;
    if (apiResponse.response.statusCode == 200) {
      showMessage(apiResponse.response.data['message'], isError: false);
      if (isGuestMode == true) {
        configModel.guestMealRate = amount.toString();
        hasActiveGuestMeal = false;
      } else {
        configModel.mealRate = amount.toString();
        hasActiveCurrentMeal = false;
      }
    } else {
      String errorMessage = apiResponse.error.toString();
      showMessage(errorMessage, isError: true);
    }
    notifyListeners();
  }

  bool hasActiveCurrentMeal = false;
  bool hasActiveGuestMeal = false;
  bool hasActiveOther = false;

  changeActiveStatus(int item) {
    if (item == 0) {
      hasActiveCurrentMeal = !hasActiveCurrentMeal;
    } else if (item == 1) {
      hasActiveGuestMeal = !hasActiveGuestMeal;
    } else if (item == 2) {
      hasActiveOther = !hasActiveOther;
    }
    notifyListeners();
  }
}
