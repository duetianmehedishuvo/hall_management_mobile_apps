import 'package:duetstahall/data/model/response/base/error_response.dart';
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioErrorType.connectTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioErrorType.other:
              errorDescription = "Connection to API server failed due to internet connection";
              break;
            case DioErrorType.receiveTimeout:
              errorDescription = "Receive timeout in connection with API server";
              break;
            case DioErrorType.response:
              switch (error.response!.statusCode) {
                case 400:
                  errorDescription =
                      'the server cannot or will not process the request due to something that is perceived to be a client error';

                  break;
                case 404:
                case 401:
                case 500:
                case 503:
                  if ((error.response!.data as Map).containsKey('message')) {
                    errorDescription = error.response!.data['message'];
                  } else if ((error.response!.data as Map).containsKey('errors')) {
                    errorDescription = error.response!.data['errors'];
                  } else if ((error.response!.data as Map).containsKey('otp_verified')) {
                    errorDescription = 'OTP Verified Failed Please Insert correct OTP';
                  } else if ((error.response!.data as Map).containsKey('detail')) {
                    errorDescription = error.response!.data['detail'];
                  } else {
                    errorDescription = error.response!.statusMessage;
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
            case DioErrorType.sendTimeout:
              errorDescription = "Send timeout with server";
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
