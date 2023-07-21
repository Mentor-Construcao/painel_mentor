import 'package:flutter/material.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/pages/licensed_companies_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Painel Mentor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LicensedCompaniesPage(),
    );
  }
}
