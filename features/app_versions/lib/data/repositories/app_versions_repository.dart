import 'package:app_versions/data/data_access/app_version_settings_firebase_cloud_data.dart';
import 'package:app_versions/data/data_access/app_versions_firebase_cloud_data.dart';
import 'package:app_versions/domain/repositories/i_app_versions_repository.dart';
import 'package:app_versions/entities.dart';

class AppVersionsRepository implements IAppVersionsRepository {
  final AppVersionsFirebaseCloudData appVersionsFirebaseCloudData;
  final AppVersionSettingsFirebaseCloudData appVersionSettingsFirebaseCloudData;

  AppVersionsRepository(
    this.appVersionsFirebaseCloudData,
    this.appVersionSettingsFirebaseCloudData,
  );

  @override
  Future<List<AppVersionRelease>> getAll() {
    return appVersionsFirebaseCloudData.getAll();
  }

  @override
  Future<AppVersionSettings> getSettings() {
    return appVersionSettingsFirebaseCloudData.get();
  }

  @override
  Future<void> put(AppVersionRelease release) async {
    await appVersionsFirebaseCloudData.add(
      release,
      release.buildNumber.toString(),
    );
  }

  @override
  Future<void> putSettings(AppVersionSettings settings) async {
    await appVersionSettingsFirebaseCloudData.put(settings);
  }
}
