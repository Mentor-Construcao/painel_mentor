import 'package:app_versions/entities.dart';
import 'package:app_versions/domain/repositories/i_app_versions_repository.dart';
import 'package:app_versions/presentation.dart';
import 'package:app_versions/usecases.dart';
import 'package:app_versions/presentation/bloc/blocs.dart';
import 'package:core/core.dart';
import 'package:core/injections_service/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'doubles/fakes.dart';
import 'doubles/use_cases.mocks.dart';

late AppVersionsBloc _bloc;
late MockGetAppVersions _getAppVersions;
late _RecordingPutAppVersion _putAppVersion;
late MockGetAppVersionSettings _getAppVersionSettings;
late MockPutAppVersionSettings _putAppVersionSettings;

void main() {
  setUp(() {
    _getAppVersions = MockGetAppVersions();
    _putAppVersion = _RecordingPutAppVersion();
    _getAppVersionSettings = MockGetAppVersionSettings();
    _putAppVersionSettings = MockPutAppVersionSettings();
    _bloc = AppVersionsBloc(
      _getAppVersions,
      _putAppVersion,
      _getAppVersionSettings,
      _putAppVersionSettings,
    );
    sl.registerSingleton<AppVersionsBloc>(_bloc);
  });

  tearDown(() async {
    await _bloc.close();
    await sl.reset();
  });

  testWidgets(
    'salva nova release com mensagens padrao consistentes com o app',
    (tester) async {
      when(_getAppVersions.call()).thenAnswer((_) async => []);
      when(_getAppVersionSettings.call())
          .thenAnswer((_) async => fakeSettings());

      await tester.pumpWidget(
        MaterialApp(
          home: AppVersionPage(
            settings: fakeSettings(),
            existingBuildNumbers: const {},
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Build incremental'),
        '205',
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        for (var attempt = 0;
            attempt < 20 && _putAppVersion.savedRelease == null;
            attempt++) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
      });

      final capturedRelease = _putAppVersion.savedRelease;

      expect(capturedRelease, isNotNull);
      expect(capturedRelease!.title, AppVersionRelease.defaultTitle);
      expect(
        capturedRelease.description,
        AppVersionRelease.defaultDescription,
      );
      expect(capturedRelease.showAlertMessage, isFalse);
      expect(capturedRelease.alertMessage, isEmpty);
    },
  );
}

class _RecordingPutAppVersion extends PutAppVersion {
  _RecordingPutAppVersion() : super(_NoopAppVersionsRepository());

  AppVersionRelease? savedRelease;

  @override
  Future<void> call(AppVersionRelease release) async {
    savedRelease = release;
  }
}

class _NoopAppVersionsRepository implements IAppVersionsRepository {
  @override
  Future<List<AppVersionRelease>> getAll() async => [];

  @override
  Future<AppVersionSettings> getSettings() async => fakeSettings();

  @override
  Future<void> put(AppVersionRelease release) async {}

  @override
  Future<void> putSettings(AppVersionSettings settings) async {}
}
