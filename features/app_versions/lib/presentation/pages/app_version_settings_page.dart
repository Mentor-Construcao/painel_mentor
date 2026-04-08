import 'package:app_versions/entities.dart';
import 'package:app_versions/presentation/bloc/blocs.dart';
import 'package:core/core.dart';
import 'package:core/injections_service/injection.dart';
import 'package:flutter/material.dart';

class AppVersionSettingsPage extends StatefulWidget {
  const AppVersionSettingsPage({
    super.key,
    required this.settings,
  });

  final AppVersionSettings settings;

  @override
  State<AppVersionSettingsPage> createState() => _AppVersionSettingsPageState();
}

class _AppVersionSettingsPageState extends State<AppVersionSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _googlePlayStoreUrlController = TextEditingController();
  final _appStoreUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _googlePlayStoreUrlController.text = widget.settings.googlePlayStoreUrl;
    _appStoreUrlController.text = widget.settings.appStoreUrl;
  }

  @override
  void dispose() {
    _googlePlayStoreUrlController.dispose();
    _appStoreUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppVersionsBloc>.value(
      value: sl<AppVersionsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Configurações da atualização')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _googlePlayStoreUrlController,
                decoration: const InputDecoration(
                  labelText: 'Link Google Play Store',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _appStoreUrlController,
                decoration: const InputDecoration(
                  labelText: 'Link App Store',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Os links são cadastrados uma única vez e podem ser editados quando necessário.',
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onConfirm,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  void _onConfirm() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final settings = AppVersionSettings(
      googlePlayStoreUrl: _googlePlayStoreUrlController.text.trim(),
      appStoreUrl: _appStoreUrlController.text.trim(),
    );

    sl<AppVersionsBloc>().add(SavedAppVersionSettingsEvent(settings));
    Navigator.of(context).pop();
  }
}
