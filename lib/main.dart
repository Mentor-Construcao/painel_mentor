import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:painel_mentor/app.dart';
import 'package:painel_mentor/firebase_options.dart';
import 'package:painel_mentor/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initInjection();
  runApp(const App());
}
