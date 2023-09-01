abstract interface class RestClient {
  Future<dynamic> get(String url);

  void dispose();
}
