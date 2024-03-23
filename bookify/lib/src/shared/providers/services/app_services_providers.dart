import 'package:bookify/src/shared/services/app_services/contacts_service/contacts_service.dart';
import 'package:bookify/src/shared/services/app_services/contacts_service/contacts_service_impl.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/notifications_service_impl.dart';
import 'package:provider/provider.dart';

/// Provider for Application Services
final appServicesProviders = [
  Provider<NotificationsService>(
    create: (_) => NotificationsServiceImpl(),
  ),
    Provider<ContactsService>(
    create: (context) => ContactsServiceImpl(),
  ),
];
