import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/hall_fee_model.dart';
import 'package:duetstahall/data/model/response/hallfee_details_model.dart';
import 'package:duetstahall/data/repository/auth_repo.dart';
import 'package:duetstahall/data/repository/hall_fee_repo.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HallFeeProvider with ChangeNotifier {
  final HallFeeRepo hallFeeRepo;
  final AuthRepo authRepo;

  HallFeeProvider({required this.hallFeeRepo, required this.authRepo});

  bool _isLoading = false;
  bool _isLoading2 = false;

  bool get isLoading => _isLoading;

  bool get isLoading2 => _isLoading2;

  // TODO:: for updateUserAllHallFeeByID
  List<HallFeeModel> hallFeeList = [];
  List<HallFeeDetailsModel> hallFeeSubList = [];
  bool isBottomLoading = false;
  bool isBottomLoading2 = false;
  int selectPage = 1;
  int selectPage2 = 1;
  bool hasNextData = false;
  bool hasNextData2 = false;

  updateUserAllHallFeeByID() {
    selectPage++;
    getUserAllHallFeeByID(page: selectPage);
    notifyListeners();
  }

  getUserAllHallFeeByID({int page = 1, bool isFirstTime = true}) async {
    if (page == 1) {
      selectPage = 1;
      hallFeeList.clear();
      hallFeeList = [];
      _isLoading = true;
      hasNextData = false;
      isBottomLoading = false;
      if (!isFirstTime) {
        notifyListeners();
      }
    } else {
      isBottomLoading = true;
      notifyListeners();
    }

    ApiResponse response = await hallFeeRepo.getUserAllHallFeeByID(selectPage);

    _isLoading = false;
    isBottomLoading = false;

    if (response.response.statusCode == 200) {
      hasNextData = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        hallFeeList.add(HallFeeModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }

  updateUserAllSubHallFeeByID(int subFeelId) {
    selectPage2++;
    getUserAllSubHallFeeByID(subFeelId, page: selectPage2);
    notifyListeners();
  }

  getUserAllSubHallFeeByID(int subFeelId, {int page = 1, bool isFirstTime = true}) async {
    if (page == 1) {
      selectPage2 = 1;
      hallFeeSubList.clear();
      hallFeeSubList = [];
      _isLoading2 = true;
      hasNextData2 = false;
      isBottomLoading2 = false;
      if (!isFirstTime) {
        notifyListeners();
      }
    } else {
      isBottomLoading2 = true;
      notifyListeners();
    }

    ApiResponse response = await hallFeeRepo.getUserAllSubHallFeeByID(subFeelId, selectPage);

    _isLoading2 = false;
    isBottomLoading2 = false;

    if (response.response.statusCode == 200) {
      hasNextData2 = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        hallFeeSubList.add(HallFeeDetailsModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }

  Future<Map> payNow(int id, int balance) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await hallFeeRepo.payNow(id, balance);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      authRepo.updateBalance(balance.toString(), false);
      authRepo.updateDue(balance.toString());
      getUserAllHallFeeByID();
      return {'status': true, 'value': balance};
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return {'status': false, 'value': "0"};
    }
  }
}
