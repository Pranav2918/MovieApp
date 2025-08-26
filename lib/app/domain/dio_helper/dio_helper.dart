import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../shared/constants/app_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => "ApiException: $message (statusCode: $statusCode)";
}

class DioHelper {
  final Dio dio = _getDio();

  final Options options = Options(
    // contentType: "application/json",
    receiveDataWhenStatusError: true,
  );

  final Map<String, dynamic> headers = {
    "Authorization": "Bearer $apiKey",
    "accept": "application/json",
  };

  // GET request
  Future<dynamic> get({
    required String url,
    bool isAuthRequired = false,
    Map<String, dynamic>? queryParams,
  }) async {
    if (isAuthRequired) {
      options.headers = headers;
    }

    try {
      Response response = await dio.get(
        url,
        options: options,
        queryParameters: queryParams,
      );
      return response.data;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      final message = error.response?.data?['status_message'] ??
          error.message ??
          "Unknown error";

      debugPrint("❌ API ERROR => $message (code: $status)");

      throw ApiException(message, statusCode: status);
    }
  }
}

// Configure Dio with interceptors
Dio _getDio() {
  final dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      debugPrint("➡️ API URL => ${options.uri}");
      debugPrint("➡️ API HEADER => ${options.headers}");
      debugPrint("➡️ API BODY => ${options.data}");
      return handler.next(options);
    },
    onResponse: (response, handler) {
      debugPrint("✅ RESPONSE => ${response.data}");
      return handler.next(response);
    },
    onError: (error, handler) {
      debugPrint("❌ STATUS CODE => ${error.response?.statusCode}");
      debugPrint("❌ ERROR DATA => ${error.response?.data}");
      return handler.next(error);
    },
  ));

  return dio;
}