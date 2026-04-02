import 'package:app_versions/domain/repositories/i_app_versions_repository.dart';
import 'package:app_versions/entities.dart';

class GetAppVersionSettings {
  final IAppVersionsRepository _appVersionsRepository;

  GetAppVersionSettings(this._appVersionsRepository);

  Future<AppVersionSettings> call() async {
    return _appVersionsRepository.getSettings();
  }
}
