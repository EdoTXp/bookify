abstract class IHttpClient {
  Future<dynamic> get(String url);

  void dispose();
}
