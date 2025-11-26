import 'package:backups/data/data_access/i_notification_remote_data_source.dart';
import 'package:dio/dio.dart';

class NotificacaoRemoteDataSource implements INotificationRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<void> enviarNotificacaoDeBackup({
    required String tokenDeNotificacao,
    required String backupID,
  }) async {
    var data = {'tokenDeNotificacao': tokenDeNotificacao, 'backupId': backupID};
    var response = await dio.post(
      'https://faas-nyc1-2ef2e6cc.doserverless.co/api/v1/web/fn-06d7c019-1ea3-4d20-a432-d460fa4358fb/notificar/backup',
      data: data,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(response.data.toString());
    }
  }
}
