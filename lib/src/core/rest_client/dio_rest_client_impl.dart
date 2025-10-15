import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/book_exception/book_exception.dart';
import 'rest_client.dart';

const _baseUrl = 'https://www.googleapis.com/books/v1/volumes?q=';

class DioRestClientImpl implements RestClient {
  final _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(minutes: 1),
    ),
  );

  @override
  Future<dynamic> get(String url) async {
    try {
      final response = await _dio.get(url);
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
