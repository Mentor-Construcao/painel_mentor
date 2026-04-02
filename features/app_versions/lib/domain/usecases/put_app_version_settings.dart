import 'package:app_versions/domain/repositories/i_app_versions_repository.dart';
import 'package:app_versions/entities.dart';

class PutAppVersionSettings {
  final IAppVersionsRepository _appVersionsRepository;

  PutAppVersionSettings(this._appVersionsRepository);

  Future<void> call(AppVersionSettings settings) async {
    return _appVersionsRepository.putSettings(settings);
  }
}
