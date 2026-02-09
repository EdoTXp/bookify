abstract interface class RestClient {
  Future<dynamic> get({
    required String baseUrl,
    Map<String, dynamic>? queryParameters,
  });
}
