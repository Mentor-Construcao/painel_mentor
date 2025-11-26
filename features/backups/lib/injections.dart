import 'package:backups/data/data_access/i_notification_remote_data_source.dart';
import 'package:backups/data/data_access/notificacao_remote_data_source.dart';
import 'package:backups/data/repositories/notificacao_repostiroty.dart';
import 'package:backups/domain/repositories/i_notificacao_repository.dart';
import 'package:backups/domain/use_cases/enviar_notificacao_de_backup.dart';
import 'package:backups/presentation/bloc/notificacao_cubit.dart';
import 'package:core/injections_service/injection.dart';

void backupInjections() {
  _remoteData();
  _repositores();
  _useCases();
  _presentation();
}

void _presentation() {
  sl.registerFactory<NotificacaoCubit>(() => NotificacaoCubit(sl()));
}

void _useCases() {
  sl.registerFactory<EnviarNotificacaoDeBackup>(
    () => EnviarNotificacaoDeBackup(repository: sl()),
  );
}

void _repositores() {
  sl.registerFactory<INotificacaoRepository>(
    () => NotificacaoRepostiroty(remoteDataSource: sl()),
  );
}

void _remoteData() {
  sl.registerFactory<INotificationRemoteDataSource>(
    () => NotificacaoRemoteDataSource(),
  );
}
