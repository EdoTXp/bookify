import 'package:bookify/src/shared/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bookify/firebase_options.dart';
import 'package:bookify/src/bookify_app.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final auth = FirebaseAuth.instanceFor(app: app);

  runApp(
    MultiProvider(
      providers: Providers.providers,
      child: BookifyApp(
        auth: auth,
      ),
    ),
  );
}
