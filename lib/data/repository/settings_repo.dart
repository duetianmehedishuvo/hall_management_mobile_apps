import 'package:dio/dio.dart';
import 'package:duetstahall/data/datasource/remote/dio/dio_client.dart';
import 'package:duetstahall/data/datasource/remote/exception/api_error_handler.dart';
import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/util/app_constant.dart';

class SettingsRepo {
  final DioClient dioClient;

  SettingsRepo({required this.dioClient});

  Response response = Response(requestOptions: RequestOptions(path: '22222'));

  Future<ApiResponse> getConfig() async {
    try {
      response = await dioClient.get(AppConstant.getConfig);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> updateMealRate(int amount, bool isGuest) async {
    try {
      response =
          await dioClient.post(isGuest == false ? AppConstant.updateMealRate : AppConstant.updateGuestMealRate, data: {"amount": amount});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> changeGuestMealAddedStatus(int code) async {
    try {
      response = await dioClient.post(AppConstant.changeGuestMealAddedStatus, data: {"statusCode": code});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> updateOfflineTakaCollectTime(String query) async {
    try {
      response = await dioClient.post(AppConstant.updateOfflineTakaCollectTime, data: {"text": query});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

}
