import 'dart:io';
import 'package:bookify/src/core/enums/rest_client_error_code.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:bookify/src/core/errors/rest_client_exception/rest_client_exception.dart';
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
        throw RestClientException(
          RestClientErrorCode.notFound,
          descriptionMessage: e.response?.statusMessage ?? 'Item not found',
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw RestClientException(
          RestClientErrorCode.connectionTimeout,
          descriptionMessage: 'Connection timed out',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw RestClientException(
          RestClientErrorCode.receiveTimeout,
          descriptionMessage: 'Receive timed out',
        );
      } else if (e.error is SocketException) {
        throw RestClientException(
          RestClientErrorCode.socketException,
          descriptionMessage: 'No internet connection',
        );
      } else {
        throw RestClientException(
          RestClientErrorCode.unknown,
          descriptionMessage: e.message,
        );
      }
    } catch (e) {
      throw RestClientException(
        RestClientErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }
}
