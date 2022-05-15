import 'package:dio/dio.dart';

import 'interfaces/http_service_interface.dart';

class DioHttpService implements IHttpService {
  final _dio = Dio();

  @override
  Future<dynamic> get(String url) async {
    final response = await _dio.get(url);
    return response.data;
  }

  @override
  void dispose() {
    _dio.close(force: true);
  }
}
