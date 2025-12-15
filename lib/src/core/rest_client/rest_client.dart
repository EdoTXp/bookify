abstract interface class RestClient {
  Future<dynamic> get({required String baseUrl, required String urlParams});
}
