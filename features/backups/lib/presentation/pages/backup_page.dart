import 'package:backups/presentation/bloc/notificacao_cubit.dart';
import 'package:core/core.dart';
import 'package:core/injections_service/injection.dart';
import 'package:flutter/material.dart';

class BackupPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tokenDeNotificacaoController =
      TextEditingController();
  final TextEditingController backupIdController = TextEditingController();
  BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificacaoCubit>(
      create: (context) => sl<NotificacaoCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text('Backup')),
        body: BlocBuilder<NotificacaoCubit, String?>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Token de Notificação'),
                  TextFormField(
                    controller: tokenDeNotificacaoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o token de notificação';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Backup ID'),
                  TextFormField(
                    controller: backupIdController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o id do backup';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context
                            .read<NotificacaoCubit>()
                            .enviarNotificacaoDeBackup(
                              tokenDeNotificacao:
                                  tokenDeNotificacaoController.text,
                              backupID: backupIdController.text,
                            );
                      }
                    },
                    child: Text('Restaurar backup no dispositivo'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
