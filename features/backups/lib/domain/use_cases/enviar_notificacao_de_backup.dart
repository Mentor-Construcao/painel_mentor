import 'package:backups/domain/repositories/i_notificacao_repository.dart';

class EnviarNotificacaoDeBackup {
  final INotificacaoRepository repository;

  EnviarNotificacaoDeBackup({required this.repository});

  Future<void> call({
    required String tokenDeNotificacao,
    required String backupID,
  }) async {
    return repository.enviarNotificacaoDeBackup(
      tokenDeNotificacao: tokenDeNotificacao,
      backupID: backupID,
    );
  }
}
