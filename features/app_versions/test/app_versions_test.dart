import 'package:app_versions/app_versions.dart';
import 'package:app_versions/entities.dart';
import 'package:app_versions/presentation/bloc/blocs.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'doubles/fakes.dart';
import 'doubles/use_cases.mocks.dart';

late AppVersionsBloc bloc;
late MockGetAppVersions _getAppVersions;
late MockPutAppVersion _putAppVersion;
late MockGetAppVersionSettings _getAppVersionSettings;
late MockPutAppVersionSettings _putAppVersionSettings;

void main() {
  setUp(() {
    _getAppVersions = MockGetAppVersions();
    _putAppVersion = MockPutAppVersion();
    _getAppVersionSettings = MockGetAppVersionSettings();
    _putAppVersionSettings = MockPutAppVersionSettings();
    bloc = AppVersionsBloc(
      _getAppVersions,
      _putAppVersion,
      _getAppVersionSettings,
      _putAppVersionSettings,
    );
  });

  test('exports appVersionsInjection', () {
    expect(appVersionsInjection, isA<Function>());
  });

  blocTest<AppVersionsBloc, AppVersionsState>(
    'carrega releases ordenadas por build decrescente junto com as configuracoes',
    build: () => bloc,
    setUp: () {
      when(_getAppVersions.call()).thenAnswer(
        (_) async => [
          fakeRelease(buildNumber: 2),
          fakeRelease(buildNumber: 5, isActive: true),
          fakeRelease(buildNumber: 3),
        ],
      );
      when(_getAppVersionSettings.call())
          .thenAnswer((_) async => fakeSettings());
    },
    act: (bloc) => bloc.add(InitializedAppVersionsEvent()),
    expect: () => [
      AppVersionsLoading(),
      AppVersionsLoaded(
        [
          fakeRelease(buildNumber: 5, isActive: true),
          fakeRelease(buildNumber: 3),
          fakeRelease(buildNumber: 2),
        ],
        fakeSettings(),
      ),
    ],
  );

  blocTest<AppVersionsBloc, AppVersionsState>(
    'ao salvar nova release ativa desativa a release ativa anterior e recarrega os dados',
    build: () => bloc,
    setUp: () {
      final existingReleases = [
        fakeRelease(buildNumber: 8, isActive: true),
        fakeRelease(buildNumber: 6),
      ];
      final updatedReleases = [
        fakeRelease(buildNumber: 10, isActive: true, mandatoryUpdate: true),
        fakeRelease(buildNumber: 8, isActive: false),
        fakeRelease(buildNumber: 6),
      ];
      var getAppVersionsCalls = 0;

      when(_getAppVersions.call()).thenAnswer((_) async {
        getAppVersionsCalls++;
        return getAppVersionsCalls == 1 ? existingReleases : updatedReleases;
      });
      when(_getAppVersionSettings.call())
          .thenAnswer((_) async => fakeSettings());
      when(_putAppVersion.call(fakeRelease(buildNumber: 8, isActive: false)))
          .thenAnswer((_) async {});
      when(
        _putAppVersion.call(
          fakeRelease(buildNumber: 10, isActive: true, mandatoryUpdate: true),
        ),
      ).thenAnswer((_) async {});
    },
    act: (bloc) => bloc.add(
      SavedAppVersionEvent(
        fakeRelease(buildNumber: 10, isActive: true, mandatoryUpdate: true),
      ),
    ),
    expect: () => [
      AppVersionsLoading(),
      AppVersionsLoaded(
        [
          fakeRelease(buildNumber: 10, isActive: true, mandatoryUpdate: true),
          fakeRelease(buildNumber: 8, isActive: false),
          fakeRelease(buildNumber: 6),
        ],
        fakeSettings(),
      ),
    ],
    verify: (_) {
      verifyInOrder([
        _getAppVersions.call(),
        _putAppVersion.call(fakeRelease(buildNumber: 8, isActive: false)),
        _putAppVersion.call(
          fakeRelease(buildNumber: 10, isActive: true, mandatoryUpdate: true),
        ),
        _getAppVersions.call(),
        _getAppVersionSettings.call(),
      ]);
    },
  );

  blocTest<AppVersionsBloc, AppVersionsState>(
    'retorna erro quando tenta salvar release com build duplicado de outra versao',
    build: () => bloc,
    setUp: () {
      when(_getAppVersions.call()).thenAnswer(
        (_) async => [
          fakeRelease(buildNumber: 7),
          fakeRelease(buildNumber: 9),
        ],
      );
    },
    act: (bloc) => bloc.add(
      SavedAppVersionEvent(
        fakeRelease(buildNumber: 9, title: 'Nova tentativa'),
        originalBuildNumber: 7,
      ),
    ),
    expect: () => [
      isA<AppVersionsError>().having(
        (state) => (state as AppVersionsError).error,
        'error',
        contains('Já existe uma release cadastrada para a versão 9.'),
      ),
    ],
    verify: (_) {
      verifyZeroInteractions(_putAppVersion);
      verifyNever(_getAppVersionSettings.call());
    },
  );

  blocTest<AppVersionsBloc, AppVersionsState>(
    'retorna erro ao inicializar quando falha ao buscar configuracoes',
    build: () => bloc,
    setUp: () {
      when(_getAppVersions.call()).thenAnswer(
        (_) async => [fakeRelease(buildNumber: 3)],
      );
      when(_getAppVersionSettings.call()).thenThrow(Exception('falha settings'));
    },
    act: (bloc) => bloc.add(InitializedAppVersionsEvent()),
    expect: () => [
      AppVersionsLoading(),
      isA<AppVersionsError>().having(
        (state) => state.error,
        'error',
        contains('falha settings'),
      ),
    ],
    verify: (_) {
      verify(_getAppVersions.call()).called(1);
      verify(_getAppVersionSettings.call()).called(1);
      verifyZeroInteractions(_putAppVersion);
      verifyZeroInteractions(_putAppVersionSettings);
    },
  );

  blocTest<AppVersionsBloc, AppVersionsState>(
    'retorna erro ao salvar release quando falha ao desativar release ativa anterior',
    build: () => bloc,
    setUp: () {
      when(_getAppVersions.call()).thenAnswer(
        (_) async => [
          fakeRelease(buildNumber: 8, isActive: true),
          fakeRelease(buildNumber: 6),
        ],
      );
      when(_putAppVersion.call(fakeRelease(buildNumber: 8, isActive: false)))
          .thenThrow(Exception('falha ao desativar release anterior'));
    },
    act: (bloc) => bloc.add(
      SavedAppVersionEvent(
        fakeRelease(buildNumber: 10, isActive: true),
      ),
    ),
    expect: () => [
      isA<AppVersionsError>().having(
        (state) => state.error,
        'error',
        contains('falha ao desativar release anterior'),
      ),
    ],
    verify: (_) {
      verify(_getAppVersions.call()).called(1);
      verify(_putAppVersion.call(fakeRelease(buildNumber: 8, isActive: false)))
          .called(1);
      verifyNever(_putAppVersion.call(fakeRelease(buildNumber: 10, isActive: true)));
      verifyNever(_getAppVersionSettings.call());
    },
  );

  blocTest<AppVersionsBloc, AppVersionsState>(
    'salva configuracoes e recarrega os dados atualizados',
    build: () => bloc,
    setUp: () {
      final updatedSettings = fakeSettings(
        googlePlayStoreUrl: 'https://play.google.com/store/apps/details?id=novo',
        appStoreUrl: 'https://apps.apple.com/app/id999999',
      );

      when(_putAppVersionSettings.call(updatedSettings))
          .thenAnswer((_) async {});
      when(_getAppVersions.call()).thenAnswer(
        (_) async => [fakeRelease(buildNumber: 11, isActive: true)],
      );
      when(_getAppVersionSettings.call()).thenAnswer((_) async => updatedSettings);
    },
    act: (bloc) => bloc.add(
      SavedAppVersionSettingsEvent(
        fakeSettings(
          googlePlayStoreUrl:
              'https://play.google.com/store/apps/details?id=novo',
          appStoreUrl: 'https://apps.apple.com/app/id999999',
        ),
      ),
    ),
    expect: () => [
      AppVersionsLoading(),
      AppVersionsLoaded(
        [fakeRelease(buildNumber: 11, isActive: true)],
        fakeSettings(
          googlePlayStoreUrl:
              'https://play.google.com/store/apps/details?id=novo',
          appStoreUrl: 'https://apps.apple.com/app/id999999',
        ),
      ),
    ],
    verify: (_) {
      verify(
        _putAppVersionSettings.call(
          fakeSettings(
            googlePlayStoreUrl:
                'https://play.google.com/store/apps/details?id=novo',
            appStoreUrl: 'https://apps.apple.com/app/id999999',
          ),
        ),
      ).called(1);
      verify(_getAppVersions.call()).called(1);
      verify(_getAppVersionSettings.call()).called(1);
    },
  );

  blocTest<AppVersionsBloc, AppVersionsState>(
    'retorna erro ao salvar configuracoes quando a persistencia falha',
    build: () => bloc,
    setUp: () {
      final updatedSettings = fakeSettings(
        googlePlayStoreUrl: 'https://play.google.com/store/apps/details?id=erro',
        appStoreUrl: 'https://apps.apple.com/app/id000000',
      );

      when(_putAppVersionSettings.call(updatedSettings))
          .thenThrow(Exception('falha ao salvar configuracoes'));
    },
    act: (bloc) => bloc.add(
      SavedAppVersionSettingsEvent(
        fakeSettings(
          googlePlayStoreUrl:
              'https://play.google.com/store/apps/details?id=erro',
          appStoreUrl: 'https://apps.apple.com/app/id000000',
        ),
      ),
    ),
    expect: () => [
      isA<AppVersionsError>().having(
        (state) => state.error,
        'error',
        contains('falha ao salvar configuracoes'),
      ),
    ],
    verify: (_) {
      verify(
        _putAppVersionSettings.call(
          fakeSettings(
            googlePlayStoreUrl:
                'https://play.google.com/store/apps/details?id=erro',
            appStoreUrl: 'https://apps.apple.com/app/id000000',
          ),
        ),
      ).called(1);
      verifyNever(_getAppVersions.call());
      verifyNever(_getAppVersionSettings.call());
    },
  );
}
