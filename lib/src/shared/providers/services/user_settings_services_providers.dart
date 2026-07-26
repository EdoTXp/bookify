import 'package:bookify/src/domain/services/auth_service/auth_service.dart';
import 'package:bookify/src/domain/services/auth_service/auth_service_impl.dart';
import 'package:bookify/src/domain/services/auth_service/auth_strategy/auth_strategy_factory.dart';
import 'package:bookify/src/domain/services/local_database_service/local_database_service.dart';
import 'package:bookify/src/domain/services/local_database_service/local_database_service_impl.dart';
import 'package:bookify/src/domain/services/storage_services/storage_service.dart';
import 'package:bookify/src/domain/services/storage_services/storage_service_impl.dart';
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
  Provider<StorageService>(
    create: (context) => StorageServiceImpl(
      storage: context.read(),
    ),
  ),

  Provider<LocalDatabaseService>(
    create: (context) => LocalDatabaseServiceImpl(
      database: context.read(),
    ),
  ),
];
