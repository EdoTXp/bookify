import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'package:bookify/src/core/errors/book_exception/book_exception.dart';
import 'rest_client.dart';

class DioRestClientImpl implements RestClient {
  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(minutes: 1),
    ),
  )..interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: MemCacheStore(),
          policy: CachePolicy.request,
          hitCacheOnErrorCodes: [401, 403],
          maxStale: const Duration(days: 7),
          priority: CachePriority.normal,
        ),
      ),
    );

  @override
  Future<dynamic> get(
      {required String baseUrl, required String urlParams}) async {
    try {
      _dio.options.baseUrl = baseUrl;

      final response = await _dio.get(urlParams);
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 404) {
        throw BookNotFoundException(response.statusMessage!);
      } else {
        throw BookException(response.statusMessage!);
      }
    } on DioException catch (e) {
      throw SocketException(e.message ?? e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
