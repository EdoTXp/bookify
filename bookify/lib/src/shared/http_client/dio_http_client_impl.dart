import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/book_error/book_error.dart';
import 'dio_http_client.dart';

class DioHttpClientImpl implements DioHttpClient {
  final _dio = Dio();

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
    } on DioException {
      throw const SocketException("Impossível se conectar com o servidor.\nVerifique se está conectado a rede WI-FI ou aos Dados Móveis.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void dispose() {
    _dio.close(force: true);
  }
}
