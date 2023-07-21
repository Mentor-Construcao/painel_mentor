import 'package:flutter/material.dart';
import 'package:painel_mentor/entities/licenced_company.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/bloc/licensed_companies_bloc.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/bloc/licensed_companies_event.dart';
import 'package:painel_mentor/injection.dart';

class LicensedCompanyPage extends StatefulWidget {
  const LicensedCompanyPage({super.key, this.company});

  final LicensedCompany? company;

  @override
  State<LicensedCompanyPage> createState() => _LicensedCompanyPageState();
}

class _LicensedCompanyPageState extends State<LicensedCompanyPage> {
  final nameController = TextEditingController();

  final urlController = TextEditingController();

  final LicensedCompaniesBloc bloc = sl<LicensedCompaniesBloc>();

  @override
  void initState() {
    if (widget.company != null) {
      nameController.text = widget.company!.name;
      urlController.text = widget.company!.accessUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onConfirm,
        child: const Icon(Icons.check),
      ),
    );
  }

  void _onConfirm() {
    if (widget.company != null) {
      if (widget.company!.name != nameController.text ||
          widget.company!.accessUrl != urlController.text) {
        var editedCompany = widget.company!.copyWith(
          name: nameController.text,
          accessUrl: urlController.text,
        );
        bloc.add(UpdatedCompanyEvent(editedCompany));
      }
    } else if (nameController.text.isNotEmpty &&
        urlController.text.isNotEmpty) {
      bloc.add(
        CreatedCompanyEvent(
          LicensedCompany(
            id: -1,
            name: nameController.text,
            accessUrl: urlController.text,
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
}
