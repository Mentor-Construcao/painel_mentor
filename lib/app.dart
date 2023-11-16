import 'package:flutter/material.dart';
import 'package:painel_mentor/routes.dart';
import 'package:painel_mentor/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Painel Mentor',
      routes: mentorRoutes,
      theme: mentorTheme,
      initialRoute: '/licensed_companies',
    );
  }
}
