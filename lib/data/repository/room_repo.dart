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
}
