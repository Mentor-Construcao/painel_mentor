import 'package:app_versions/entities.dart';

abstract class IAppVersionsRepository {
  Future<List<AppVersionRelease>> getAll();
  Future<void> put(AppVersionRelease release);
  Future<AppVersionSettings> getSettings();
  Future<void> putSettings(AppVersionSettings settings);
}
