import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio getDio() {
  Dio dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options, handler) {
      debugPrint("API URL => ${options.uri}");
      debugPrint("API HEADER => ${options.headers}");
      debugPrint("API BODY => ${options.data}");
      return handler.next(options);
    },
    onResponse: (Response response, handler) {
      debugPrint("RESPONSE => ${response.data}");
      return handler.next(response);
    },
    onError: (DioException error, handler) {
      debugPrint("STATUS CODE => ${error.response?.statusCode ?? ""}");
      switch (error.response?.statusCode) {
        case 200:
        case 201:
          debugPrint("Success");
        case 404:
          debugPrint("Page not found");
        case 500:
          debugPrint("Internal server error");
        default:
          debugPrint("Hit an error while communication");
      }
      debugPrint("ERROR DATA => ${error.response?.data ?? ""}");
      return handler.next(error);
    },
  ));
  return dio;
}