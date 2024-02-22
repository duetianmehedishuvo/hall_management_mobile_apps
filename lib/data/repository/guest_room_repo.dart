import 'package:dio/dio.dart';
import 'package:duetstahall/data/datasource/remote/dio/dio_client.dart';
import 'package:duetstahall/data/datasource/remote/exception/api_error_handler.dart';
import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestRoomRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  GuestRoomRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getAllRoomAssignList(int page) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('getAllRoomAssignList?page=$page');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getMyRoomAssignByID(int page) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    var studentID = sharedPreferences.getString(AppConstant.studentID);
    try {
      response = await dioClient.get('getMyRoomAssignByID?studentID=$studentID&page=$page');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> addGuestRoomBook(String roomNO, String startTime, String endTime, String purpose, String phoneNo) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient
          .post('addGuestRoomBook', data: {'roomNO': roomNO, 'start_time': startTime, 'end_time': endTime, 'purpose': purpose, 'phoneNo': phoneNo});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> acceptRoom(String id, String status) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post('acceptRoom', data: {'id': id, 'status': status});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> deleteGuestRoomBook(String id) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('deleteGuestRoomBook?id=$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}
