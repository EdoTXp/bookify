import 'package:bookify/src/core/services/auth_service/auth_service.dart';
import 'package:bookify/src/core/services/auth_service/auth_service_impl.dart';
import 'package:bookify/src/core/services/auth_service/auth_strategy/auth_strategy_factory.dart';
import 'package:bookify/src/core/services/storage_services/storage_services.dart';
import 'package:bookify/src/core/services/storage_services/storage_services_impl.dart';
import 'package:provider/provider.dart';

final userSettingsServicesProviders = [
  Provider<AuthStrategyFactory>(
    create: (_) => AuthStrategyFactory(),
  ),
  Provider<AuthService>(
    create: (context) => AuthServiceImpl(
      authRepository: context.read(),
      authStrategyFactory: context.read(),
    ),
  ),
  Provider<StorageServices>(
    create: (context) => StorageServicesImpl(
      storage: context.read(),
    ),
  ),
];
