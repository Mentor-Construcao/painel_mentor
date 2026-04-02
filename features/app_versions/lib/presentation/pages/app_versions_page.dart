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
                    'Historico de envios',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (state.releases.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nenhuma versao cadastrada.'),
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
              child: Text('Nao foi possivel carregar as versoes.'),
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
                  'Configuracao remota',
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
              settings.playStoreUrl.isEmpty
                  ? 'Play Store: nao configurado'
                  : 'Play Store: ${settings.playStoreUrl}',
            ),
            const SizedBox(height: 4),
            Text(
              settings.appStoreUrl.isEmpty
                  ? 'App Store: nao configurado'
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
    return Card(
      child: InkWell(
        onTap: () => _onEditVersion(context, release),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${release.title} - build ${release.buildNumber}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (isCurrent) _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 8),
              Text(release.description),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      release.isActive ? 'Status: ativa' : 'Status: inativa',
                    ),
                  ),
                  Switch(
                    value: release.isActive,
                    onChanged: (value) => _onToggleActive(
                      context,
                      release,
                      value,
                    ),
                  ),
                ],
              ),
              if (release.hasAlertMessage) ...[
                const SizedBox(height: 8),
                Text(
                  'Alerta: ${release.alertMessage}',
                  style: const TextStyle(color: Colors.orange),
                ),
              ],
              if (release.mandatoryUpdate) ...[
                const SizedBox(height: 8),
                const Text(
                  'Campo de atualizacao obrigatoria preparado para uso futuro.',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Text(
        'ATUAL',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _onAddVersion(BuildContext context, AppVersionSettings settings) async {
    await Navigator.of(context).pushNamed(
      '/app_version',
      arguments: AppVersionPageArgs(
        settings: settings,
        currentActiveBuildNumber:
            _currentActiveBuildNumber(context.read<AppVersionsBloc>().state),
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
        currentActiveBuildNumber:
            _currentActiveBuildNumber(context.read<AppVersionsBloc>().state),
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

  int? _currentActiveBuildNumber(AppVersionsState state) {
    if (state is! AppVersionsLoaded) {
      return null;
    }
    return _latestActiveRelease(state.releases)?.buildNumber;
  }

  void _onToggleActive(
    BuildContext context,
    AppVersionRelease release,
    bool value,
  ) {
    context.read<AppVersionsBloc>().add(
          SavedAppVersionEvent(
            release.copyWith(isActive: value),
          ),
        );
  }
}
