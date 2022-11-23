import 'package:dio/dio.dart';

import '../errors/book_error.dart';
import 'interfaces/http_service_interface.dart';

class DioHttpService implements IHttpService {
  final _dio = Dio();

  @override
  Future<dynamic> get(String url) async {
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 204) {
      throw BookNotFoundException(response.statusMessage!);
    } else {
      throw BookException(response.statusMessage!);
    }
  }

  @override
  void dispose() {
    _dio.close(force: true);
  }
}
