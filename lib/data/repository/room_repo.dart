import 'package:dio/dio.dart';
import 'package:duetstahall/data/datasource/remote/dio/dio_client.dart';
import 'package:duetstahall/data/datasource/remote/exception/api_error_handler.dart';
import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/util/app_constant.dart';

class RoomRepo {
  final DioClient dioClient;

  RoomRepo({required this.dioClient});

  Response response = Response(requestOptions: RequestOptions(path: '22222'));

  Future<ApiResponse> getRoomInfo(String roomNO) async {
    try {
      response = await dioClient.get(AppConstant.getRoomInfo + roomNO);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> updateRoomStatus(String id, int available) async {
    try {
      response = await dioClient.get('updateRoomStatusByStudentID?id=$id&isAvaible=$available');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> addRoom(String roomID, String studentID, int year) async {
    try {
      response = await dioClient.post('addRoom', data: {"roomNo": roomID, "studentID": studentID, "year": year});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> deleteRoom(String roomID) async {
    try {
      response = await dioClient.delete('${AppConstant.deleteStudentsRoom}$roomID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}
