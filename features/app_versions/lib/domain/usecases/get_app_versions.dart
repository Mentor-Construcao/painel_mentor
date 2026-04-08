import 'package:app_versions/domain/repositories/i_app_versions_repository.dart';
import 'package:app_versions/entities.dart';

class GetAppVersions {
  final IAppVersionsRepository _appVersionsRepository;

  GetAppVersions(this._appVersionsRepository);

  Future<List<AppVersionRelease>> call() async {
    return _appVersionsRepository.getAll();
  }
}
