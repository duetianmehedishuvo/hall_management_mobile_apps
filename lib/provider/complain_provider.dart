import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/complain_model.dart';
import 'package:duetstahall/data/repository/auth_repo.dart';
import 'package:duetstahall/data/repository/complain_repo.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ComplainProvider with ChangeNotifier {
  final ComplainRepo complainRepo;
  final AuthRepo authRepo;

  ComplainProvider({required this.complainRepo, required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // TODO:: for updateUserAllHallFeeByID
  List<ComplainModel> allComplainList = [];
  bool isBottomLoading = false;
  int selectPage = 1;
  bool hasNextData = false;

  updateAllComplain({bool isAdmin = false}) {
    selectPage++;
    getAllComplain(page: selectPage, isAdmin: isAdmin);
    notifyListeners();
  }

  getAllComplain({int page = 1, bool isFirstTime = true, bool isAdmin = false}) async {
    if (page == 1) {
      selectPage = 1;
      allComplainList.clear();
      allComplainList = [];
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
    ApiResponse response;
    if (isAdmin) {
      response = await complainRepo.getUserAllComplain(selectPage);
    } else {
      response = await complainRepo.getUserAllComplainByID(selectPage);
    }

    _isLoading = false;
    isBottomLoading = false;

    if (response.response.statusCode == 200) {
      hasNextData = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        allComplainList.add(ComplainModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }

  Future<Map> replyComplain(int id, String reply) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await complainRepo.replyComplain(id, reply);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);

      getAllComplain(isAdmin: true);
      return {'status': true, 'value': ''};
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return {'status': false, 'value': "0"};
    }
  }

  Future<bool> deleteComplain(int id, int index) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await complainRepo.deleteComplain(id);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      allComplainList.removeAt(index);
      notifyListeners();
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
    }
    return true;
  }

  Future<bool> addComplain(String subject, String complain) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await complainRepo.addComplain(subject, complain);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      getAllComplain();
      return true;
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return false;
    }
  }

  Future<bool> editComplain(int id, String subject, String complain) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await complainRepo.editComplain(id, subject, complain);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      getAllComplain();
      return true;
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return false;
    }
  }

  List<String> feeType = ['monthly fee', 'other fee'];
  String selectFeeType = 'monthly fee';

  changeFeeType(String value) {
    selectFeeType = value;
    notifyListeners();
  }
}
