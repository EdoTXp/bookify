abstract interface class DioHttpClient {
  Future<dynamic> get(String url);

  void dispose();
}
