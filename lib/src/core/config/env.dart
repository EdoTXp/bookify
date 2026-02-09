import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(
    varName: 'GOOGLE_BOOKS_API_KEY',
    obfuscate: true,
  )
  /// Google Books API key, used to authenticate requests to the Google Books API.
  static final String googleBooksApiKey = _Env.googleBooksApiKey;
}
