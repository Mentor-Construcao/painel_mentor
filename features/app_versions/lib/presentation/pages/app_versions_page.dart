import 'package:app_versions/entities.dart';
import 'package:app_versions/presentation/bloc/blocs.dart';
import 'package:core/core.dart';
import 'package:core/injections_service/injection.dart';
import 'package:flutter/material.dart';

import 'app_version_page.dart';

class AppVersionsPage extends StatelessWidget {
  const AppVersionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppVersionsBloc>.value(
      value: sl<AppVersionsBloc>()..add(InitializedAppVersionsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Controle de versões do app'),
        ),
        body: BlocConsumer<AppVersionsBloc, AppVersionsState>(
          listener: (context, state) {
            if (state is AppVersionsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AppVersionsLoading || state is AppVersionsInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AppVersionsLoaded) {
              final latestActiveRelease = _latestActiveRelease(state.releases);
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSettingsCard(context, state.settings),
                  const SizedBox(height: 16),
                  Text(
                    'Histórico de envios',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (state.releases.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nenhuma versão cadastrada.'),
                      ),
                    ),
                  ...state.releases.map(
                    (release) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildReleaseCard(
                        context,
                        release,
                        isCurrent: latestActiveRelease?.buildNumber ==
                            release.buildNumber,
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: Text('Não foi possível carregar as versões.'),
            );
          },
        ),
        floatingActionButton: BlocBuilder<AppVersionsBloc, AppVersionsState>(
          builder: (context, state) {
            final settings = state is AppVersionsLoaded
                ? state.settings
                : AppVersionSettings.empty;
            return FloatingActionButton(
              onPressed: () => _onAddVersion(context, settings),
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    AppVersionSettings settings,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Configuração remota',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => _onEditSettings(context, settings),
                  child: const Text('Editar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              settings.googlePlayStoreUrl.isEmpty
                  ? 'Google Play Store: não configurado'
                  : 'Google Play Store: ${settings.googlePlayStoreUrl}',
            ),
            const SizedBox(height: 4),
            Text(
              settings.appStoreUrl.isEmpty
                  ? 'App Store: não configurado'
                  : 'App Store: ${settings.appStoreUrl}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReleaseCard(
    BuildContext context,
    AppVersionRelease release, {
    required bool isCurrent,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: () => _onEditVersion(context, release),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          release.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Build ${release.buildNumber}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(release.isActive ? 'Ativa' : 'Inativa'),
                    selected: release.isActive,
                    showCheckmark: false,
                    avatar: Icon(
                      release.isActive
                          ? Icons.check_circle
                          : Icons.pause_circle_outline,
                      size: 18,
                      color: release.isActive ? Colors.green : Colors.black,
                    ),
                    color: WidgetStateColor.resolveWith((states) {
                      if (release.isActive) {
                        return Colors.green.withValues(alpha: 0.35);
                      }
                      return Colors.grey.withValues(alpha: 0.12);
                    }),
                    onSelected: (_) => _onToggleActive(context, release),
                  ),
                  if (isCurrent)
                    Chip(
                      label: const Text('Atual'),
                      avatar: const Icon(Icons.push_pin_outlined, size: 18),
                      backgroundColor: Colors.blue.withValues(alpha: 0.35),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(release.description),
              if (release.hasAlertMessage) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.32),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 2),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          release.alertMessage,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (release.mandatoryUpdate) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.error.withValues(alpha: 0.24),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.system_update_alt_rounded,
                        color: colorScheme.onErrorContainer,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Atualização obrigatória',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _onAddVersion(BuildContext context, AppVersionSettings settings) async {
    await Navigator.of(context).pushNamed(
      '/app_version',
      arguments: AppVersionPageArgs(
        settings: settings,
        existingBuildNumbers: _existingBuildNumbers(
          context.read<AppVersionsBloc>().state,
        ),
      ),
    );
  }

  void _onEditVersion(
    BuildContext context,
    AppVersionRelease release,
  ) async {
    final state = context.read<AppVersionsBloc>().state;
    final settings =
        state is AppVersionsLoaded ? state.settings : AppVersionSettings.empty;
    await Navigator.of(context).pushNamed(
      '/app_version',
      arguments: AppVersionPageArgs(
        release: release,
        settings: settings,
        existingBuildNumbers: _existingBuildNumbers(
          context.read<AppVersionsBloc>().state,
        ),
      ),
    );
  }

  void _onEditSettings(
    BuildContext context,
    AppVersionSettings settings,
  ) async {
    await Navigator.of(context).pushNamed(
      '/app_version_settings',
      arguments: settings,
    );
  }

  AppVersionRelease? _latestActiveRelease(List<AppVersionRelease> releases) {
    for (final release in releases) {
      if (release.isActive) {
        return release;
      }
    }
    return null;
  }

  Set<int> _existingBuildNumbers(AppVersionsState state) {
    if (state is! AppVersionsLoaded) {
      return {};
    }
    return state.releases.map((release) => release.buildNumber).toSet();
  }

  Future<void> _onToggleActive(
    BuildContext context,
    AppVersionRelease release,
  ) async {
    final shouldActivate = !release.isActive;
    if (shouldActivate) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Ativar versão'),
          content: Text(
            'Deseja ativar a versão build ${release.buildNumber}? A versão ativa atual será inativada automaticamente.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Ativar'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return;
      }
    }

    if (!context.mounted) {
      return;
    }

    context.read<AppVersionsBloc>().add(
          SavedAppVersionEvent(
            release.copyWith(isActive: shouldActivate),
            originalBuildNumber: release.buildNumber,
          ),
        );
  }

}
