import 'package:app_versions/domain/repositories/i_app_versions_repository.dart';
import 'package:app_versions/entities.dart';

class PutAppVersion {
  final IAppVersionsRepository _appVersionsRepository;

  PutAppVersion(this._appVersionsRepository);

  Future<void> call(AppVersionRelease release) async {
    return _appVersionsRepository.put(release);
  }
}
