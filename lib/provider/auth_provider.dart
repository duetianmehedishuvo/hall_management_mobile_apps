import 'dart:async';

import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/base/error_response.dart';
import 'package:duetstahall/data/model/response/student_model1.dart';
import 'package:duetstahall/data/repository/auth_repo.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  changeLoading() {
    _isLoading = false;
  }

  //TODO:: for Sign Up Section

  Future<bool> signup(String studentID, String name, String phoneNumber, String password, String details, String homeTown,
      String researchArea, String jobPosition, String futureGoal, String whatssApp, String email, String motive) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.signup(studentID, name, selectedDepartments, phoneNumber, selectedBlood, password, details,
        homeTown, researchArea, jobPosition, futureGoal, whatssApp, email, motive);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response.statusCode == 200) {
      showMessage(apiResponse.response.data['message'], isError: false);
      notifyListeners();
      return true;
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.toString();
      }
      showMessage(errorMessage, isError: true);
      return false;
    }
  }

  //TODO:: for reset password in Section
  //
  // Future resetPasswordConfirm(String emailOrPhone, String newPassword, String code, Function callback) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   ApiResponse apiResponse = await authRepo.setNewPassword(emailOrPhone, newPassword, code);
  //   _isLoading = false;
  //   if (apiResponse.response.statusCode == 200) {
  //     callback(true, "Password Set Successfully");
  //   } else {
  //     callback(false, apiResponse.error.toString());
  //     //print(response.statusCode);
  //   }
  //   notifyListeners();
  // }

  //TODO:: for Sign in Section

  StudentModel1 studentModel1 = StudentModel1();

  Future<bool> signIn(String studentID, String password) async {
    _isLoading = true;
    studentModel1 = StudentModel1();
    notifyListeners();
    ApiResponse apiResponse = await authRepo.login(studentID, password);
    _isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      if (authRepo.checkTokenExist()) {
        authRepo.clearUserInformation();
        authRepo.clearToken();
      }
      authRepo.saveUserToken(apiResponse.response.data['token'].toString());
      studentModel1 = StudentModel1.fromJson(apiResponse.response.data['user']);
      authRepo.saveUserInformation(
          studentModel1.studentID.toString(), studentModel1.name!, studentModel1.balance!.toString(), studentModel1.role! as int);
      showMessage('Login Successfully', isError: false);
      getUserInfo();
      notifyListeners();
      return true;
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.toString();
      }
      showMessage(errorMessage, isError: true);
      notifyListeners();
      return false;
    }
  }

  // for OTP send
  // Future otpSend(String emailORPhone, bool isEmail, Function callback) async {
  //   _isLoading = true;
  //   data = emailORPhone;
  //   isNumber = isEmail;
  //   notifyListeners();
  //   ApiResponse apiResponse = await authRepo.otpSend(emailORPhone, isEmail);
  //   _isLoading = false;
  //
  //   if (apiResponse.response.statusCode == 200) {
  //     startTimer();
  //     callback(true, apiResponse.response.data['message']);
  //   } else {
  //     callback(false, apiResponse.error.toString());
  //   }
  //   notifyListeners();
  // }
  //
  // // for Reset OTP Send
  // Future resetOtpSend(String emailORPhone, bool isEmail, Function callback) async {
  //   _isLoading = true;
  //   data = emailORPhone;
  //   isNumber = isEmail;
  //   notifyListeners();
  //   ApiResponse apiResponse = await authRepo.resetOtpSend(emailORPhone, isEmail);
  //   _isLoading = false;
  //
  //   if (apiResponse.response.statusCode == 200) {
  //     startTimer();
  //     callback(true, apiResponse.response.data['message']);
  //   } else {
  //     callback(false, apiResponse.error.toString());
  //   }
  //   notifyListeners();
  // }
  //
  // // for OTP Verify
  //
  // otpVerify(String code, Function callback) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   ApiResponse apiResponse = await authRepo.otpVerify(data, code, isNumber);
  //   _isLoading = false;
  //
  //   if (apiResponse.response.statusCode == 200) {
  //     callback(true, 'Successfully Verified');
  //   } else {
  //     callback(false, apiResponse.error.toString());
  //   }
  //   notifyListeners();
  // }

  //// TODO: for send User Information
  String dateTime = "${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}";
  String dateTimeForUser = "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}";

  void showDateDialog(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.dark(),
          child: Container(
            height: 300,
            color: Colors.black,
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                maximumDate: DateTime.now(),
                dateOrder: DatePickerDateOrder.dmy,
                onDateTimeChanged: (dateTimeValue) {
                  dateTime = "${dateTimeValue.year.toString()}-${dateTimeValue.month.toString()}-${dateTimeValue.day.toString()}";
                  dateTimeForUser = "${dateTimeValue.day.toString()}/${dateTimeValue.month.toString()}/${dateTimeValue.year.toString()}";
                  notifyListeners();
                }),
          ), // This will change to light theme.
        );
      },
    );
  }

  List<String> genderLists = ["Male", "Female", "Other"];

  String selectGender = "Male";

  changeGenderStatus(String status) {
    selectGender = status;
    notifyListeners();
  }

  //TODO: for Logout
  Future<bool> logout() async {
    authRepo.clearToken();
    authRepo.clearUserInformation();
    return true;
  }

  //TODO: for Logout
  bool checkTokenExist() {
    return authRepo.checkTokenExist();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  // get User INFO:
  String name = '';
  String studentID = '';
  String balance = '';
  int userStatus = -1;

  void getUserInfo({bool isFirstTime = true}) {
    name = authRepo.getUserName();
    studentID = authRepo.getStudentID();
    balance = authRepo.getAmount();
    userStatus = authRepo.getUserStatus();
    if (!isFirstTime) notifyListeners();
  }

  bool isSelectEmail = false;

  void changeSelectStatus(bool value) {
    isSelectEmail = value;
    notifyListeners();
  }

  bool _isActiveRememberMe = true;

  bool get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  // for Department Dropdown
  List<String> departments = ["CSE", "EEE", "CE", "IP", "ME", "MME", "CFE", "TE", "ARCE"];
  String selectedDepartments = "CSE";

  changeDepartments(String value) {
    selectedDepartments = value;
    notifyListeners();
  }

  // for Blood Group Dropdown
  List<String> bloodGroups = ["A+", "A-", "O+", "O-", "B+", "B-", "AB+", "AB-"];
  String selectedBlood = "A+";

  changeBloodGroups(String value) {
    selectedBlood = value;
    notifyListeners();
  }
}