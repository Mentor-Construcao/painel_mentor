import 'package:app_versions/entities.dart';
import 'package:app_versions/presentation/bloc/blocs.dart';
import 'package:core/core.dart';
import 'package:core/injections_service/injection.dart';
import 'package:flutter/material.dart';

class AppVersionPageArgs {
  final AppVersionRelease? release;
  final AppVersionSettings settings;
  final int? currentActiveBuildNumber;

  const AppVersionPageArgs({
    this.release,
    required this.settings,
    this.currentActiveBuildNumber,
  });
}

class AppVersionPage extends StatefulWidget {
  const AppVersionPage({
    super.key,
    this.release,
    required this.settings,
    this.currentActiveBuildNumber,
  });

  final AppVersionRelease? release;
  final AppVersionSettings settings;
  final int? currentActiveBuildNumber;

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
    }
    _buildNumberController.addListener(_onBuildChanged);
  }

  @override
  void dispose() {
    _buildNumberController
      ..removeListener(_onBuildChanged)
      ..dispose();
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
          title: Text(widget.release == null ? 'Nova versao' : 'Editar versao'),
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
                readOnly: widget.release != null,
                validator: (value) {
                  final buildNumber = int.tryParse(value ?? '');
                  if (buildNumber == null) {
                    return 'Informe um build valido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildComparisonCard(),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: _titleController,
                label: 'Titulo',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o titulo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: _descriptionController,
                label: 'Descricao',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a descricao';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Exibir mensagem de alerta'),
                subtitle: const Text(
                  'Use para avisos de risco, impacto ou cuidado antes da atualizacao.',
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
                title: const Text('Estrutura para atualizacao obrigatoria'),
                subtitle: const Text(
                  'Mantem o campo preparado para uso futuro sem alterar o modelo.',
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

  Widget _buildComparisonCard() {
    final buildNumber = int.tryParse(_buildNumberController.text);
    final currentActiveBuildNumber = widget.currentActiveBuildNumber;
    final comparison = buildNumber == null || currentActiveBuildNumber == null
        ? null
        : AppVersionRelease(
            buildNumber: buildNumber,
            title: '',
            description: '',
            showAlertMessage: false,
            alertMessage: '',
            mandatoryUpdate: false,
            isActive: false,
            createdAt: '',
          ).compareWithRemoteBuild(currentActiveBuildNumber);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comparacao incremental',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(currentActiveBuildNumber == null
                ? 'Nao existe versao ativa no momento.'
                : 'Build da versao ativa: $currentActiveBuildNumber'),
            const SizedBox(height: 4),
            Text(_comparisonText(comparison)),
          ],
        ),
      ),
    );
  }

  String _comparisonText(VersionBuildComparison? comparison) {
    switch (comparison) {
      case VersionBuildComparison.equal:
        return 'O build informado e igual ao da versao ativa.';
      case VersionBuildComparison.lower:
        return 'O build informado esta abaixo da versao ativa atual.';
      case null:
        return 'Informe um build para comparar.';
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _onBuildChanged() {
    setState(() {});
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

    sl<AppVersionsBloc>().add(SavedAppVersionEvent(release));
    Navigator.of(context).pop();
  }
}
