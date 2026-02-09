import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'package:bookify/src/core/errors/book_exception/book_exception.dart';
import 'rest_client.dart';

class DioRestClientImpl implements RestClient {
  final _dio =
      Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(minutes: 1),
          ),
        )
        ..interceptors.add(
          DioCacheInterceptor(
            options: CacheOptions(
              store: MemCacheStore(),
              hitCacheOnErrorCodes: [401, 403],
              maxStale: const Duration(days: 7),
            ),
          ),
        );

  @override
  Future<dynamic> get({
    required String baseUrl,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        baseUrl,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw BookNotFoundException(
          e.response?.statusMessage ?? 'Book not found',
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw BookException(
          e.response?.statusMessage ?? 'An error occurred',
        );
      } else {
        throw SocketException(e.message ?? e.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
