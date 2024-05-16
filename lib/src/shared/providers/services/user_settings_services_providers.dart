import 'package:bookify/src/shared/services/auth_service/auth_service.dart';
import 'package:bookify/src/shared/services/auth_service/auth_service_impl.dart';
import 'package:bookify/src/shared/services/storage_services/storage_services.dart';
import 'package:bookify/src/shared/services/storage_services/storage_services_impl.dart';
import 'package:provider/provider.dart';

final userSettingsServicesProviders = [
  Provider<AuthService>(
    create: (context) => AuthServiceImpl(
      authRepository: context.read(),
    ),
  ),
  Provider<StorageServices>(
    create: (context) => StorageServicesImpl(
      storage: context.read(),
    ),
  ),
];
