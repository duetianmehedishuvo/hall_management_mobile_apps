import 'package:duetstahall/data/model/response/base/error_response.dart';
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.unknown:
              errorDescription = "Connection to API server failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 400:
                  errorDescription =
                      'the server cannot or will not process the request due to something that is perceived to be a client error';

                  break;
                case 404:
                case 401:
                case 500:
                case 503:
                  try{
                    if ((error.response!.data as Map).containsKey('message')) {
                      errorDescription = error.response!.data['message'];
                    } else if ((error.response!.data as Map).containsKey('errors')) {
                      errorDescription = error.response!.data['errors'];
                    } else if ((error.response!.data as Map).containsKey('otp_verified')) {
                      errorDescription = 'OTP Verified Failed Please Insert correct OTP';
                    } else if ((error.response!.data as Map).containsKey('detail')) {
                      errorDescription = error.response!.data['detail'];
                    } else {
                      errorDescription = error.response!.statusMessage.toString();
                    }
                  }catch(e){
                    errorDescription = 'something went wrong';
                  }

                  break;
                default:
                  ErrorResponse errorResponse = ErrorResponse.fromJson(error.response!.data);
                  if (errorResponse.error.isNotEmpty) {
                    errorDescription = errorResponse;
                  } else {
                    errorDescription = "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            case DioExceptionType.badCertificate:
              // TODO: Handle this case.
              break;
            case DioExceptionType.connectionError:
              // TODO: Handle this case.
              break;
          }
        } else {
          errorDescription = "Unexpected error occurred";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
