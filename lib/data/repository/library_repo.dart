import 'package:dio/dio.dart';
import 'package:duetstahall/data/datasource/remote/dio/dio_client.dart';
import 'package:duetstahall/data/datasource/remote/exception/api_error_handler.dart';
import 'package:duetstahall/data/model/response/base/api_response.dart';

class LibraryRepo {
  final DioClient dioClient;

  LibraryRepo({required this.dioClient});

  Future<ApiResponse> book(String title, String author, String category, String price, int isUpdate, int id) async {
    Response response = Response(requestOptions: RequestOptions(path: ''));
    try {
      response =
          await dioClient.post('book', data: {'title': title, 'author': author, 'category': category, 'price': price, 'isUpdate': isUpdate, 'id': id});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> deleteBook(int id) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.delete('deleteBook?id=$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getAllBooks(String category, int page) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('getAllBooks?category=$category&page=$page');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> searchQueryBook(String query, int page) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('searchQueryBook?query=$query&page=$page');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> bookIssue(int bookId, int studentId, int isUpdate, int id) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post('bookIssue', data: {'book_id': bookId, 'student_id': studentId, 'isUpdate': isUpdate, 'id': id});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> bookPurchedHistory(int page, int studentID, String type, int isAdmin) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('bookPurchedHistory?studentID=$studentID&type=$type&isAdmin=$isAdmin&page=$page');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> bookHistory(int page, int bookId) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('bookHistory?bookID=$bookId&page=$page');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> deleteAllCard() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('deleteAllCard');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> checkCardIssue() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get('checkCardIssue');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}
