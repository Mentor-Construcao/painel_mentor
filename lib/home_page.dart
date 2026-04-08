import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Painel Mentor'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/app_versions');
              },
              child: const Text('Versões de Aplicativo'),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/licensed_companies');
              },
              child: const Text('Empresas Licenciadas'),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/backup');
              },
              child: const Text('Backup'),
            )
          ],
        ),
      ),
    );
  }
}
