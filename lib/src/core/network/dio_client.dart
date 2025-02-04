import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    // Add Interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // You can add authentication headers or logging here
        if (kDebugMode) {
          print('endpoint: ${options.path}');
          print('Request: ${options.method} ${options.path}');
        }
        // For example, adding Authorization header if needed
        // options.headers['Authorization'] = 'Bearer YOUR_TOKEN_HERE';
        return handler.next(options); // Continue with request
      },
      onResponse: (response, handler) {
        // You can log or handle response here
        if (kDebugMode) {
          print('Response: ${response.statusCode} ${response.data}');
        }
        return handler.next(response); // Continue with response
      },
      onError: (DioException e, handler) {
        // Handle any error responses here
        if (kDebugMode) {
          print('Error: ${e.message}');
        }
        return handler.next(e); // Continue with error
      },
    ));
  }

  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(
        '${ApiEndpoints.baseUrl}/$path',
        queryParameters: queryParams,
      );
    } on DioException {
      rethrow; // Handle exception
    }
  }

  // POST request
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(
        '${ApiEndpoints.baseUrl}/$path',
        data: data,
      );
    } on DioException {
      rethrow; // Handle exception
    }
  }
}

Dio dio = Dio();
DioClient dioClient = DioClient(dio);
