import 'package:dio/dio.dart';
import 'package:duetstahall/data/datasource/remote/dio/dio_client.dart';
import 'package:duetstahall/data/datasource/remote/exception/api_error_handler.dart';
import 'package:duetstahall/data/model/response/base/api_response.dart';

class CommunityRepo {
  final DioClient dioClient;

  CommunityRepo({required this.dioClient});

  Future<ApiResponse> post(String details, int isUpdate, int id) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post('post', data: {'details': details, 'isUpdate': isUpdate, 'id': id});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> deletePost(int id) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.delete('deletePost?id=$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getAllPost(int page) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('getAllPost?page=$page');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getAllPostByStudentID(int page) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('getAllPostByStudentID?page=$page');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> comment(int communityId, String comment, int isUpdate, int id) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      print({'community_id': communityId, 'comment': comment, 'isUpdate': isUpdate, 'id': id});
      response = await dioClient.post('comment', data: {'community_id': communityId, 'comment': comment, 'isUpdate': isUpdate, 'id': id});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> deleteCommend(int id) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.delete('deleteCommend?id=$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getAllPostCommend(int page, int communityId) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('getAllPostCommend?community_id=$communityId&page=$page');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}
