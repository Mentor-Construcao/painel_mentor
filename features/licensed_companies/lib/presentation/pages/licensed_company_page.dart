import 'package:core/core.dart';
import 'package:core/injections_service/injection.dart';
import 'package:flutter/material.dart';
import 'package:licensed_companies/entities.dart';

import '../blocs/blocs.dart';

class LicensedCompanyPage extends StatefulWidget {
  const LicensedCompanyPage({super.key, this.company});

  final LicensedCompany? company;

  @override
  State<LicensedCompanyPage> createState() => _LicensedCompanyPageState();
}

class _LicensedCompanyPageState extends State<LicensedCompanyPage> {
  final nameController = TextEditingController();

  final urlController = TextEditingController();

  bool? exclued = false;
  bool? autoBackup = false;
  @override
  void initState() {
    if (widget.company != null) {
      nameController.text = widget.company!.name;
      urlController.text = widget.company!.accessUrl;
      exclued = widget.company?.exclued;
      autoBackup = widget.company?.autoBackup;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LicensedCompaniesBloc>(
      create: (context) => sl<LicensedCompaniesBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Código: ${widget.company?.id ?? ''}"),
              _buildTextFormField(
                controller: nameController,
                label: 'Nome',
                action: TextInputAction.next,
              ),
              _buildTextFormField(
                controller: urlController,
                label: 'URL de acesso',
                action: TextInputAction.done,
              ),
              _excluidCheckBox(),
              _autoBakcupCheckBox(),
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

  void _onConfirm() {
    if (widget.company != null) {
      if (widget.company!.name != nameController.text ||
          widget.company!.accessUrl != urlController.text ||
          widget.company!.exclued != exclued ||
          widget.company!.autoBackup != autoBackup) {
        var editedCompany = widget.company!.copyWith(
          name: nameController.text,
          accessUrl: urlController.text,
          exclued: exclued,
          autoBackup: autoBackup,
        );
        sl<LicensedCompaniesBloc>().add(UpdatedCompanyEvent(editedCompany));
      }
    } else if (nameController.text.isNotEmpty &&
        urlController.text.isNotEmpty) {
      sl<LicensedCompaniesBloc>().add(
        CreatedCompanyEvent(
          LicensedCompany(
            id: -1,
            name: nameController.text,
            accessUrl: urlController.text,
            exclued: exclued ?? false,
            autoBackup: autoBackup ?? false,
          ),
        ),
      );
    }
    Navigator.pop(context);
  }

  Widget _buildTextFormField({
    String? label,
    String? text,
    TextInputAction? action,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 29.0),
      child: TextFormField(
        key: ObjectKey(text ?? label),
        controller: controller,
        textInputAction: action,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
        ),
      ),
    );
  }

  Widget _excluidCheckBox() => Row(
        children: [
          Checkbox(
              value: exclued ?? false,
              onChanged: (value) {
                setState(() {
                  exclued = value;
                });
              }),
          const Text('Excluído/Inativado')
        ],
      );
  Widget _autoBakcupCheckBox() => Row(
        children: [
          Checkbox(
              value: autoBackup ?? false,
              onChanged: (value) {
                setState(() {
                  autoBackup = value;
                });
              }),
          const Text('Backup Automático')
        ],
      );
}
