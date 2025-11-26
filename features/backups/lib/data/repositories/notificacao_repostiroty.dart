import 'package:backups/data/data_access/i_notification_remote_data_source.dart';
import 'package:backups/domain/repositories/i_notificacao_repository.dart';

class NotificacaoRepostiroty implements INotificacaoRepository {
  final INotificationRemoteDataSource _remoteDataSource;

  NotificacaoRepostiroty({
    required INotificationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<void> enviarNotificacaoDeBackup({
    required String tokenDeNotificacao,
    required String backupID,
  }) async {
    return _remoteDataSource.enviarNotificacaoDeBackup(
      tokenDeNotificacao: tokenDeNotificacao,
      backupID: backupID,
    );
  }
}
