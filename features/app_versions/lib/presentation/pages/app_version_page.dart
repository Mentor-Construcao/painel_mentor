import 'package:app_versions/entities.dart';
import 'package:app_versions/presentation/bloc/blocs.dart';
import 'package:core/core.dart';
import 'package:core/injections_service/injection.dart';
import 'package:flutter/material.dart';

class AppVersionPageArgs {
  final AppVersionRelease? release;
  final AppVersionSettings settings;
  final Set<int> existingBuildNumbers;

  const AppVersionPageArgs({
    this.release,
    required this.settings,
    required this.existingBuildNumbers,
  });
}

class AppVersionPage extends StatefulWidget {
  const AppVersionPage({
    super.key,
    this.release,
    required this.settings,
    required this.existingBuildNumbers,
  });

  final AppVersionRelease? release;
  final AppVersionSettings settings;
  final Set<int> existingBuildNumbers;

  @override
  State<AppVersionPage> createState() => _AppVersionPageState();
}

class _AppVersionPageState extends State<AppVersionPage> {
  final _formKey = GlobalKey<FormState>();
  final _buildNumberController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _alertMessageController = TextEditingController();

  bool _showAlertMessage = false;
  bool _mandatoryUpdate = false;
  @override
  void initState() {
    super.initState();
    if (widget.release != null) {
      _buildNumberController.text = widget.release!.buildNumber.toString();
      _titleController.text = widget.release!.title;
      _descriptionController.text = widget.release!.description;
      _alertMessageController.text = widget.release!.alertMessage;
      _showAlertMessage = widget.release!.showAlertMessage;
      _mandatoryUpdate = widget.release!.mandatoryUpdate;
    } else {
      _titleController.text = 'Nova versão disponível';
      _descriptionController.text =
          'Uma nova versão do aplicativo está disponível na loja.';
    }
  }

  @override
  void dispose() {
    _buildNumberController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _alertMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppVersionsBloc>.value(
      value: sl<AppVersionsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.release == null ? 'Nova versão' : 'Editar versão'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildTextFormField(
                controller: _buildNumberController,
                label: 'Build incremental',
                keyboardType: TextInputType.number,
                enabled: widget.release == null,
                validator: (value) {
                  final buildNumber = int.tryParse(value ?? '');
                  if (buildNumber == null) {
                    return 'Informe um build válido';
                  }
                  if (widget.release == null &&
                      widget.existingBuildNumbers.contains(buildNumber)) {
                    return 'Já existe uma release cadastrada para essa versão';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: _titleController,
                label: 'Título',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: _descriptionController,
                label: 'Descrição',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a descrição';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Exibir mensagem de alerta'),
                subtitle: const Text(
                  'Use para avisos de risco, impacto ou cuidado antes da atualização.',
                ),
                value: _showAlertMessage,
                onChanged: (value) {
                  setState(() {
                    _showAlertMessage = value;
                  });
                },
              ),
              if (_showAlertMessage) ...[
                _buildTextFormField(
                  controller: _alertMessageController,
                  label: 'Mensagem de alerta',
                  maxLines: 3,
                  validator: (value) {
                    if (_showAlertMessage &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Informe a mensagem de alerta';
                    }
                    return null;
                  },
                ),
              ],
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Atualização obrigatória'),
                subtitle: const Text(
                  'Quando ativada, o usuário precisa atualizar o app para continuar usando.',
                ),
                value: _mandatoryUpdate,
                onChanged: (value) {
                  setState(() {
                    _mandatoryUpdate = value;
                  });
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onConfirm,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: enabled,
      readOnly: !enabled,
      canRequestFocus: enabled,
      enableInteractiveSelection: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _onConfirm() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final release = AppVersionRelease(
      buildNumber: int.parse(_buildNumberController.text),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      showAlertMessage: _showAlertMessage,
      alertMessage:
          _showAlertMessage ? _alertMessageController.text.trim() : '',
      mandatoryUpdate: _mandatoryUpdate,
      isActive: widget.release?.isActive ?? false,
      createdAt: widget.release?.createdAt ?? DateTime.now().toIso8601String(),
    );

    sl<AppVersionsBloc>().add(
      SavedAppVersionEvent(
        release,
        originalBuildNumber: widget.release?.buildNumber,
      ),
    );
    Navigator.of(context).pop();
  }
}
