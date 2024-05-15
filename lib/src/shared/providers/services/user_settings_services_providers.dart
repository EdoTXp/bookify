import 'package:bookify/src/shared/services/auth_service/auth_service.dart';
import 'package:bookify/src/shared/services/auth_service/auth_service_impl.dart';
import 'package:provider/provider.dart';

final userSettingsServicesProviders = [
  Provider<AuthService>(
    create: (context) => AuthServiceImpl(
      authRepository: context.read(),
    ),
  ),
];
