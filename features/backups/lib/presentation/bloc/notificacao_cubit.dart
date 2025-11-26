import 'package:backups/domain/use_cases/enviar_notificacao_de_backup.dart';
import 'package:core/core.dart';

class NotificacaoCubit extends Cubit<String?> {
  final EnviarNotificacaoDeBackup _enviarNotificacaoDeBackup;

  NotificacaoCubit(this._enviarNotificacaoDeBackup) : super(null);

  Future<void> enviarNotificacaoDeBackup({
    required String tokenDeNotificacao,
    required String backupID,
  }) async {
    try {
      emit('enivando notificação...');
      await _enviarNotificacaoDeBackup.call(
        backupID: backupID,
        tokenDeNotificacao: tokenDeNotificacao,
      );
      emit('notificação enviada com sucesos');
    } catch (e, s) {
      emit('falha ao enviar notificação de backup, verifique as informações');
      addError(e, s);
    }
  }
}
