import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../utils.dart/token_storage.dart';
import 'api_constants.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    // Add Interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await TokenStorage.instance.getToken();
        options.followRedirects = true;

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          debugPrint(token);
        }

        if (kDebugMode) {
          print('endpoint: ${options.path}');
          print('Request: ${options.method} ${options.path}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('Response: ${response.statusCode} ${response.data}');
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (kDebugMode) {
          print('Error: ${e.message}');
        }
        return handler.next(e);
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
      rethrow;
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
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.delete(
        '${ApiEndpoints.baseUrl}/$path',
        data: data,
      );
    } on DioException {
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(
        '${ApiEndpoints.baseUrl}/$path',
        data: data,
      );
    } on DioException {
      rethrow;
    }
  }
}

Dio dio = Dio();
DioClient dioClient = DioClient(dio);
