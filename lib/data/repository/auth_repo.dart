import 'package:dio/dio.dart';
import 'package:duetstahall/data/datasource/remote/dio/dio_client.dart';
import 'package:duetstahall/data/datasource/remote/exception/api_error_handler.dart';
import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

double progressPercent = 0;

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> login(String studentId, String password) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));

    try {
      Map map = {};
      map.addAll({"studentID": studentId});
      map.addAll({'password': password});
      response = await dioClient.post(AppConstant.loginURI, data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getBalance(String studentId) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));

    try {
      response = await dioClient.get('getBalance?studentID=$studentId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> signup(
      String studentID,
      String name,
      String department,
      String phoneNumber,
      String bloodGroup,
      String password,
      String details,
      String homeTown,
      String researchArea,
      String jobPosition,
      String futureGoal,
      String whatssApp,
      String email,
      String motive) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));

    try {
      Map map = {};
      map.addAll({
        "studentID": studentID,
        "name": name,
        "department": department,
        "phoneNumber": phoneNumber,
        "bloodGroup": bloodGroup,
        "password": password,
        "details": details,
        "homeTown": homeTown,
        "researchArea": researchArea,
        "jobPosition": jobPosition,
        "futureGoal": futureGoal,
        "whatssApp": whatssApp,
        "email": email,
        "motive": motive
      });
      response = await dioClient.post(AppConstant.signUPURI, data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> updateStudentInfo(
      String studentID,
      String name,
      String department,
      String phoneNumber,
      String bloodGroup,
      String details,
      String homeTown,
      String researchArea,
      String jobPosition,
      String futureGoal,
      String whatssApp,
      String email,
      String motive) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));

    try {
      Map map = {};
      map.addAll({
        "studentID": studentID,
        "name": name,
        "department": department,
        "phoneNumber": phoneNumber,
        "bloodGroup": bloodGroup,
        "details": details,
        "homeTown": homeTown,
        "researchArea": researchArea,
        "jobPosition": jobPosition,
        "futureGoal": futureGoal,
        "whatssApp": whatssApp,
        "email": email,
        "motive": motive
      });
      response = await dioClient.post(AppConstant.updateUser, data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> setNewPassword(String password, String newPassword) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      Map map = {};

      map.addAll({"password": password, "newPassword": newPassword});
      response = await dioClient.post(AppConstant.setNewPasswordURI, data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  //TODO: for save User Information
  Future<void> saveUserInformation(String userID, String name, String amount, String due, int status) async {
    try {
      await sharedPreferences.setString(AppConstant.studentID, userID);
      await sharedPreferences.setString(AppConstant.userName, name);
      await sharedPreferences.setString(AppConstant.amount, amount);
      await sharedPreferences.setString(AppConstant.due, due);
      await sharedPreferences.setInt(AppConstant.userStatus, status);
      getUserName();
      getStudentID();
      getUserStatus();
      getAmount();
      getDue();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeUserName(String value) async {
    try {
      await sharedPreferences.setString(AppConstant.userName, value);
    } catch (e) {
      rethrow;
    }
  }

  //TODO:: for get User Information
  String getStudentID() {
    return sharedPreferences.getString(AppConstant.studentID) ?? "";
  }

  String getUserName() {
    return sharedPreferences.getString(AppConstant.userName) ?? "";
  }

  // TODO; clear all user Information
  Future<bool> clearUserInformation() async {
    await sharedPreferences.remove(AppConstant.studentID);
    await sharedPreferences.remove(AppConstant.userName);
    return await sharedPreferences.remove(AppConstant.userStatus);
  }

  // for  user Balance
  Future<void> saveUserToken(String token) async {
    dioClient.token = token;
    dioClient.dio!.options.headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};

    try {
      await sharedPreferences.setString(AppConstant.token, token);
    } catch (e) {
      rethrow;
    }
  }

  // for  user token
  Future<void> updateBalance(String balance, bool isAdd) async {
    try {
      int amount = int.parse(getAmount());
      if (isAdd) {
        amount += int.parse(balance);
      } else {
        amount -= int.parse(balance);
      }
      await sharedPreferences.setString(AppConstant.amount, amount.toString());
    } catch (e) {
      rethrow;
    }
  }

  // for  user token
  Future<void> updateBalance1(String balance) async {
    try {
      await sharedPreferences.setString(AppConstant.amount, balance.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDue1(String balance) async {
    try {
      await sharedPreferences.setString(AppConstant.due, balance.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDue(String balance) async {
    try {
      int amount = int.parse(getDue());
      amount -= int.parse(balance);
      await sharedPreferences.setString(AppConstant.due, amount.toString());
    } catch (e) {
      rethrow;
    }
  }

  bool checkTokenExist() {
    return sharedPreferences.containsKey(AppConstant.token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstant.token) ?? "";
  }

  String getAmount() {
    return sharedPreferences.getString(AppConstant.amount) ?? "0";
  }

  String getDue() {
    return sharedPreferences.getString(AppConstant.due) ?? "0";
  }

  int getUserStatus() {
    return sharedPreferences.getInt(AppConstant.userStatus) ?? -1;
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstant.token);
  }

  Future<bool> clearToken() async {
    return sharedPreferences.remove(AppConstant.token);
  }
}
