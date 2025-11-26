abstract class INotificacaoRepository {
  Future<void> enviarNotificacaoDeBackup({
    required String tokenDeNotificacao,
    required String backupID,
  });
}
