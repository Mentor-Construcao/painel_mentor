import 'package:app_versions/data/data.dart';
import 'package:app_versions/domain/repositories/i_app_versions_repository.dart';
import 'package:app_versions/presentation/bloc/blocs.dart';
import 'package:app_versions/usecases.dart';
import 'package:core/injections_service/injection.dart';

void appVersionsInjection() {
  _repositories();
  _useCases();
  _blocs();
}

void _repositories() {
  sl.registerFactory<IAppVersionsRepository>(
    () => AppVersionsRepository(
      AppVersionsFirebaseCloudData(),
      AppVersionSettingsFirebaseCloudData(),
    ),
  );
}

void _useCases() {
  sl.registerSingleton<GetAppVersions>(
    GetAppVersions(
      sl<IAppVersionsRepository>(),
    ),
  );
  sl.registerSingleton<PutAppVersion>(
    PutAppVersion(
      sl<IAppVersionsRepository>(),
    ),
  );
  sl.registerSingleton<GetAppVersionSettings>(
    GetAppVersionSettings(
      sl<IAppVersionsRepository>(),
    ),
  );
  sl.registerSingleton<PutAppVersionSettings>(
    PutAppVersionSettings(
      sl<IAppVersionsRepository>(),
    ),
  );
}

void _blocs() {
  sl.registerSingleton<AppVersionsBloc>(
    AppVersionsBloc(
      sl<GetAppVersions>(),
      sl<PutAppVersion>(),
      sl<GetAppVersionSettings>(),
      sl<PutAppVersionSettings>(),
    ),
  );
}
