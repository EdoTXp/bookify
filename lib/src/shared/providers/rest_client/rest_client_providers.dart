import 'package:bookify/src/core/rest_client/dio_rest_client_impl.dart';
import 'package:bookify/src/core/rest_client/rest_client.dart';
import 'package:provider/provider.dart';

final restClientProvider = [
  Provider<RestClient>(
    create: (_) => DioRestClientImpl(),
  ),
];
