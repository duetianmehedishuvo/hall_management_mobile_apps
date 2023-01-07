import 'dart:async';

import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/base/error_response.dart';
import 'package:duetstahall/data/model/response/room_model.dart';
import 'package:duetstahall/data/model/response/student_model.dart';
import 'package:duetstahall/data/repository/auth_repo.dart';
import 'package:duetstahall/helper/database_helper.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CallBackResponse {
  bool status;
  String message;

  CallBackResponse({this.status = false, this.message = ''});
}

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String data = '';
  bool isNumber = false;

  //TODO:: for Sign Up Section

  Future signup(String firstName, String lastName, String password, Function callback) async {
    _isLoading = true;
    notifyListeners();
    String gender = '';
    if (genderLists[0] == selectGender) {
      gender = 'M';
    } else if (genderLists[1] == selectGender) {
      gender = 'F';
    } else {
      gender = '0';
    }
    ApiResponse apiResponse = await authRepo.signup(firstName, lastName, dateTime, gender, data, password);
    _isLoading = false;
    if (apiResponse.response.statusCode == 201) {
      if (authRepo.checkTokenExist()) {
        authRepo.clearUserInformation();
        authRepo.clearToken();
      }
      authRepo.saveUserToken(apiResponse.response.data['token'].toString());
      authRepo.saveUserInformation(
          apiResponse.response.data['id'].toString(),
          '${apiResponse.response.data['first_name']} ${apiResponse.response.data['last_name']}',
          '${apiResponse.response.data['profile_image']}',
          '${apiResponse.response.data['code']}',
          '${apiResponse.response.data['email']}');
      name = '${apiResponse.response.data['first_name']} ${apiResponse.response.data['last_name']}';
      userID = '${apiResponse.response.data['id']}';
      userCode = '${apiResponse.response.data['code']}';
      profileImage = '${apiResponse.response.data['profile_image']}';
      callback(true, 'Signup Successfully');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.toString();
      }
      callback(false, errorMessage);
    }
    notifyListeners();
  }

  //TODO:: for reset password in Section

  Future resetPasswordConfirm(String emailOrPhone, String newPassword, String code, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.setNewPassword(emailOrPhone, newPassword, code);
    _isLoading = false;
    if (apiResponse.response.statusCode == 200) {
      callback(true, "Password Set Successfully");
    } else {
      callback(false, apiResponse.error.toString());
      //print(response.statusCode);
    }
    notifyListeners();
  }

  //TODO:: for Sign in Section

  Future<CallBackResponse> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.login(email, password, false, onSendProgress: (int sentBytes, int totalBytes) {
      progressPercent = sentBytes / totalBytes * 100;
      showLog("Progress: $progressPercent %");
      if (progressPercent == 100) {
        // dispose();
        showLog('finished');
      }
    });
    _isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      if (authRepo.checkTokenExist()) {
        authRepo.clearUserInformation();
        authRepo.clearToken();
      }
      authRepo.saveUserToken(apiResponse.response.data['token'].toString());
      authRepo.saveUserInformation(
          apiResponse.response.data['id'].toString(),
          '${apiResponse.response.data['first_name']} ${apiResponse.response.data['last_name']}',
          '${apiResponse.response.data['profile_image']}',
          '${apiResponse.response.data['code']}',
          '${apiResponse.response.data['email']}');
      name = '${apiResponse.response.data['first_name']} ${apiResponse.response.data['last_name']}';
      userID = '${apiResponse.response.data['id']}';
      userCode = '${apiResponse.response.data['code']}';
      profileImage = '${apiResponse.response.data['profile_image']}';
      notifyListeners();
      return CallBackResponse(status: true, message: 'Login Successfully');
    } else {
      notifyListeners();
      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.toString();
      }
      return CallBackResponse(status: false, message: errorMessage);
    }
  }

  // for OTP send
  Future otpSend(String emailORPhone, bool isEmail, Function callback) async {
    _isLoading = true;
    data = emailORPhone;
    isNumber = isEmail;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.otpSend(emailORPhone, isEmail);
    _isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      startTimer();
      callback(true, apiResponse.response.data['message']);
    } else {
      callback(false, apiResponse.error.toString());
    }
    notifyListeners();
  }

  // for Reset OTP Send
  Future resetOtpSend(String emailORPhone, bool isEmail, Function callback) async {
    _isLoading = true;
    data = emailORPhone;
    isNumber = isEmail;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.resetOtpSend(emailORPhone, isEmail);
    _isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      startTimer();
      callback(true, apiResponse.response.data['message']);
    } else {
      callback(false, apiResponse.error.toString());
    }
    notifyListeners();
  }

  // for OTP Verify

  otpVerify(String code, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.otpVerify(data, code, isNumber);
    _isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      callback(true, 'Successfully Verified');
    } else {
      callback(false, apiResponse.error.toString());
    }
    notifyListeners();
  }

  /////TODO: for time count

  int minutes = 5;
  int seconds = 0;
  bool isEmail = true;
  late Timer _timer;

  void startTimer() {
    seconds = 0;
    minutes = 5;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        notifyListeners();
      } else {
        if (minutes > 0) {
          minutes--;
          seconds = 59;
          notifyListeners();
        } else {
          timer.cancel();
        }
      }
    });
  }

  void resetTime() {
    _timer.cancel();
    // seconds = 0;
    // minutes = 5;
    otpSend(data, isNumber, (bool status, String message) {
      if (status) {
        Fluttertoast.showToast(msg: message);
      } else {
        Fluttertoast.showToast(msg: message, backgroundColor: Colors.red);
      }
    });
    notifyListeners();
  }

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
  String profileImage = '';
  String userID = '';
  String userCode = '';

  void getUserInfo() {
    name = authRepo.getUserName();
    profileImage = authRepo.getUserProfile();
    userID = authRepo.getUserID();
    userCode = authRepo.getUserCode();
    notifyListeners();
  }

  List<String> bloodGroups = ["A+", "A-", "O+", "O-", "B+", "B-", "AB+", "AB-"];
  String selectedBlood = "A+";

  changeBloodGroups(String value) {
    selectedBlood = value;
    notifyListeners();
  }

  DateTime selectedDate = DateTime.now();

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: Helper.navigatorKey.currentState!.context,
        initialDate: selectedDate,
        firstDate: DateTime(2000, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  final DatabaseHelper _databaseService = DatabaseHelper();

  addStudent(StudentModel studentModel) {
    _databaseService.insertStudent(studentModel).then((value) {
      if (value != 0) {
        print('Save successful');
      } else {
        print('Save failed');
      }
    });
  }

  Future<List<String>> getSuggestionsData(String data) {
    return _databaseService.selectItems(data);
  }

  String selectStudent1 = '';
  String selectStudent2 = '';
  String selectStudent3 = '';
  String selectStudent4 = '';
  String selectStudent5 = '';
  String selectStudent6 = '';
  String selectStudentExtra = '';

  resetStudents() {
    selectStudent1 = '';
    selectStudent2 = '';
    selectStudent3 = '';
    selectStudent4 = '';
    selectStudent5 = '';
    selectStudent6 = '';
    selectStudentExtra = '';
    notifyListeners();
  }

  changeValue(String value, int position) {
    if (position == 0) {
      selectStudent1 = value;
    } else if (position == 1) {
      selectStudent2 = value;
    } else if (position == 2) {
      selectStudent3 = value;
    } else if (position == 3) {
      selectStudent4 = value;
    } else if (position == 4) {
      selectStudent5 = value;
    } else if (position == 5) {
      selectStudent6 = value;
    } else {
      selectStudentExtra = value;
    }
    notifyListeners();
  }

  ////////////////////// TODO FOr Room Section
  addRooms(RoomModel roomModel) {
    _databaseService.insertRoom(roomModel).then((value) {
      if (value != 0) {
        print('Save successful');
      } else {
        print('Save failed');
      }
    });
  }
}
