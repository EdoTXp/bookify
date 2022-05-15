abstract class IHttpService {
  Future<dynamic> get(String url);

  void dispose();
}
