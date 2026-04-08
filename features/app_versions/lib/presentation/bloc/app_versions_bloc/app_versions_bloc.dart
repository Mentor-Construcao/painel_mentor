import 'dart:async';

import 'package:app_versions/entities.dart';
import 'package:app_versions/usecases.dart';
import 'package:core/core.dart';

part 'app_versions_event.dart';
part 'app_versions_state.dart';

class AppVersionsBloc extends Bloc<AppVersionsEvent, AppVersionsState> {
  final GetAppVersions _getAppVersions;
  final PutAppVersion _putAppVersion;
  final GetAppVersionSettings _getAppVersionSettings;
  final PutAppVersionSettings _putAppVersionSettings;

  AppVersionsBloc(
    this._getAppVersions,
    this._putAppVersion,
    this._getAppVersionSettings,
    this._putAppVersionSettings,
  ) : super(AppVersionsInitial()) {
    on<InitializedAppVersionsEvent>(_onInitializedAppVersionsEvent);
    on<SavedAppVersionEvent>(_onSavedAppVersionEvent);
    on<SavedAppVersionSettingsEvent>(_onSavedAppVersionSettingsEvent);
  }

  Future<void> _loadData(Emitter<AppVersionsState> emit) async {
    emit(AppVersionsLoading());
    try {
      final results = await Future.wait<dynamic>([
        _getAppVersions(),
        _getAppVersionSettings(),
      ]);
      final releases = (results[0] as List<AppVersionRelease>)
        ..sort((a, b) => b.buildNumber.compareTo(a.buildNumber));
      final settings = results[1] as AppVersionSettings;
      emit(AppVersionsLoaded(releases, settings));
    } catch (e, s) {
      emit(AppVersionsError(e.toString()));
      addError(e, s);
    }
  }

  FutureOr<void> _onInitializedAppVersionsEvent(
    InitializedAppVersionsEvent event,
    Emitter<AppVersionsState> emit,
  ) async {
    await _loadData(emit);
  }

  FutureOr<void> _onSavedAppVersionEvent(
    SavedAppVersionEvent event,
    Emitter<AppVersionsState> emit,
  ) async {
    try {
      final releases = await _getAppVersions();
      final versionAlreadyExists = releases.any(
        (release) =>
            release.buildNumber == event.release.buildNumber &&
            release.buildNumber != event.originalBuildNumber,
      );

      if (versionAlreadyExists) {
        throw Exception(
          'Já existe uma release cadastrada para a versão ${event.release.buildNumber}.',
        );
      }

      if (event.release.isActive) {
        for (final release in releases) {
          if (release.buildNumber != event.release.buildNumber &&
              release.isActive) {
            await _putAppVersion(
              release.copyWith(isActive: false),
            );
          }
        }
      }
      await _putAppVersion(event.release);
      await _loadData(emit);
    } catch (e, s) {
      emit(AppVersionsError(e.toString()));
      addError(e, s);
    }
  }

  FutureOr<void> _onSavedAppVersionSettingsEvent(
    SavedAppVersionSettingsEvent event,
    Emitter<AppVersionsState> emit,
  ) async {
    try {
      await _putAppVersionSettings(event.settings);
      await _loadData(emit);
    } catch (e, s) {
      emit(AppVersionsError(e.toString()));
      addError(e, s);
    }
  }
}
