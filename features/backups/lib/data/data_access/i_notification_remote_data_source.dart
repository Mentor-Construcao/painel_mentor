abstract class INotificationRemoteDataSource {
  Future<void> enviarNotificacaoDeBackup({
    required String tokenDeNotificacao,
    required String backupID,
  });
}
