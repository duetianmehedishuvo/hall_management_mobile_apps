import 'package:duetstahall/data/datasource/remote/dio/dio_client.dart';
import 'package:duetstahall/data/datasource/remote/exception/api_error_handler.dart';
import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/helper/number_helper.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

double progressPercent = 0;

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> login(String emailOrPhone, String password, bool isPhone, {ProgressCallback? onSendProgress}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      Map map = {};
      if (isPhone) {
        map.addAll({"mobile": emailOrPhone});
      } else {
        map.addAll({"email": emailOrPhone});
      }
      map.addAll({'password': password});
      response = await dioClient.post(AppConstant.loginURI, data: map, onSendProgress: onSendProgress);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> signup(String firstName, String lastName, String dob, String gender, String emailOrPhone, String password,
      {ProgressCallback? onSendProgress}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      Map map = {};
      if (isNumeric(emailOrPhone)) {
        map.addAll({"mobile": emailOrPhone});
      } else {
        map.addAll({"email": emailOrPhone});
      }
      map.addAll({"first_name": firstName, "last_name": lastName, "password": password, "date_of_birth": dob, "gender": gender});
      response = await dioClient.post(AppConstant.signupURI, data: map, onSendProgress: onSendProgress);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> setNewPassword(String emailOrPhone, String newPassword, String code, {ProgressCallback? onSendProgress}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      Map map = {};
      if (isNumeric(emailOrPhone)) {
        map.addAll({"phone": emailOrPhone});
      } else {
        map.addAll({"email": emailOrPhone});
      }
      map.addAll({"otp": code, "new_password": newPassword});
      response = await dioClient.put(AppConstant.setNewPasswordURI, data: map, onSendProgress: onSendProgress);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> otpSend(String emailOrPhone, bool isEmail, {ProgressCallback? onSendProgress}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      Map map = {};
      if (isEmail) {
        map = {"email": emailOrPhone};
      } else {
        map = {"phone": emailOrPhone};
      }
      response = await dioClient.post(AppConstant.otpSendURI, data: map, onSendProgress: onSendProgress);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> resetOtpSend(String emailOrPhone, bool isEmail, {ProgressCallback? onSendProgress}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      Map map = {};
      if (isEmail) {
        map = {"email": emailOrPhone};
      } else {
        map = {"phone": emailOrPhone};
      }
      response = await dioClient.post(AppConstant.otpSendURI, data: map, onSendProgress: onSendProgress);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> otpVerify(String emailOrPhone, String code, bool isEmail, {ProgressCallback? onSendProgress}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      Map map = {};
      if (isEmail) {
        map = {"email": emailOrPhone, "code": code};
      } else {
        map = {"phone": emailOrPhone, "code": code};
      }
      response = await dioClient.post(AppConstant.otpVerifyURI, data: map, onSendProgress: onSendProgress);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  //TODO: for save User Information
  Future<void> saveUserInformation(String userID, String name, String image, String code, String email) async {
    try {
      await sharedPreferences.setString(AppConstant.userID, userID);
      await sharedPreferences.setString(AppConstant.userEmail, email);
      await sharedPreferences.setString(AppConstant.usercode, code);
      await sharedPreferences.setString(AppConstant.userName, name);
      await sharedPreferences.setString(AppConstant.userProfileImage, image);
      getUserProfile();
      getUserName();
      getUserID();
      getUserCode();
      getUserEmail();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeUserImage(String image) async {
    try {
      await sharedPreferences.setString(AppConstant.userProfileImage, image);
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
  String getUserID() {
    return sharedPreferences.getString(AppConstant.userID) ?? "";
  }

  String getUserName() {
    return sharedPreferences.getString(AppConstant.userName) ?? "";
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstant.userEmail) ?? "";
  }

  String getUserCode() {
    return sharedPreferences.getString(AppConstant.usercode) ?? "";
  }

  String getUserProfile() {
    return sharedPreferences.getString(AppConstant.userProfileImage) ?? "";
  }

  // TODO; clear all user Information
  Future<bool> clearUserInformation() async {
    await sharedPreferences.remove(AppConstant.userID);
    await sharedPreferences.remove(AppConstant.userName);
    await sharedPreferences.remove(AppConstant.userEmail);
    await sharedPreferences.remove(AppConstant.usercode);
    return await sharedPreferences.remove(AppConstant.userProfileImage);
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient.token = token;
    dioClient.dio!.options.headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};

    try {
      await sharedPreferences.setString(AppConstant.token, token);
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

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstant.token);
  }

  Future<bool> clearToken() async {
    return sharedPreferences.remove(AppConstant.token);
  }
}
