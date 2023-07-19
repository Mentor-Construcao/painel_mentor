import 'package:flutter/material.dart';
import 'package:painel_mentor/entities/licenced_company.dart';
import 'package:painel_mentor/feature/licensed_companies/bloc/licensed_companies_bloc.dart';
import 'package:painel_mentor/feature/licensed_companies/bloc/licensed_companies_event.dart';
import 'package:uuid/uuid.dart';

class LicensedCompanyPage extends StatelessWidget {
  LicensedCompanyPage({super.key, this.company});

  final LicensedCompany? company;
  final nameController = TextEditingController();
  final urlController = TextEditingController();
  final LicensedCompaniesBloc bloc = LicensedCompaniesBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(company?.id ?? ''),
            TextFormField(),
            TextFormField(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
    );
  }

  onConfirm() {
    if (company != null) {
      if (company!.name != nameController.text ||
          company!.accessUrl != urlController.text) {
        var editedCompany = company!.copyWith(
          name: nameController.text,
          accessUrl: urlController.text,
        );
        bloc.add(UpdatedCompanyEvent(editedCompany));
      }
    } else {
      bloc.add(
        CreatedCompanyEvent(
          LicensedCompany(
            id: const Uuid().v4(),
            name: nameController.text,
            accessUrl: urlController.text,
          ),
        ),
      );
    }
  }
}
