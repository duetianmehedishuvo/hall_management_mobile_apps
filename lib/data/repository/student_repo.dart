import 'package:dio/dio.dart';
import 'package:duetstahall/data/datasource/remote/dio/dio_client.dart';
import 'package:duetstahall/data/datasource/remote/exception/api_error_handler.dart';
import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  StudentRepo({required this.dioClient, required this.sharedPreferences});

  Response response = Response(requestOptions: RequestOptions(path: '22222'));

  Future<ApiResponse> getStudentInfoByID(String studentID) async {
    try {
      response = await dioClient.get(AppConstant.getStudentInfoByID + studentID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> searchStudent(String query) async {
    try {
      response = await dioClient.get(AppConstant.searchStudent + query);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getAllMealByStudentID() async {
    try {
      var studentID = sharedPreferences.getString(AppConstant.studentID);
      response = await dioClient.get(AppConstant.getAllMealByStudentID + studentID.toString());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> addMeal(String time) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      var studentID = sharedPreferences.getString(AppConstant.studentID);
      response = await dioClient.post(AppConstant.addMeal, data: {"studentID": studentID, "time": time});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> addGuestMeal(String time) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      var studentID = sharedPreferences.getString(AppConstant.studentID);
      response = await dioClient.post('addGuestMeal?studentID=$studentID&created_at=$time');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> deleteMealByID(String time) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.delete(AppConstant.deleteMealByID + time);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> deleteGuestMealByID(String time) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.delete(AppConstant.deleteGuestMealByID + time);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> updateBalance(String balance) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      var studentID = sharedPreferences.getString(AppConstant.studentID);
      response = await dioClient.get("${AppConstant.updateBalance}$balance&studentID=$studentID&isAddition=0");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> shareBalance(String balance, String toStudentID) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      var studentID = sharedPreferences.getString(AppConstant.studentID);
      response = await dioClient.post("shareBalance?balance=$balance&fromStudentID=$studentID&toStudentID=$toStudentID");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> userAllTransaction(int page) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      var studentID = sharedPreferences.getString(AppConstant.studentID);
      response = await dioClient.get("getUserAllTransAction?studentID=$studentID&page=$page");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> checkTodayMeal(String time) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get("checkTodayMeal?created_at=$time");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}
