import 'package:bookify/src/shared/routes/routes.dart';

import 'package:flutter/widgets.dart';

class NotificationNavigator {
  static void navigateTo(
    String pageRoute,
    Object? arguments,
  ) {
    assert(
      pageRoute.startsWith('/'),
      'The page route must be initiated with /',
    );

    Navigator.pushNamed(
      Routes.navigatorKey!.currentContext!,
      pageRoute,
      arguments: arguments,
    );
  }
}
