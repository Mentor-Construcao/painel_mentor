import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painel_mentor/feature/licensed_companies/bloc/licensed_companies_bloc.dart';
import 'package:painel_mentor/feature/licensed_companies/bloc/licensed_companies_state.dart';

class LicensedCompaniesPage extends StatefulWidget {
  const LicensedCompaniesPage({super.key});

  @override
  State<LicensedCompaniesPage> createState() => _LicensedCompaniesPageState();
}

class _LicensedCompaniesPageState extends State<LicensedCompaniesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: BlocBuilder<LicensedCompaniesBloc, LicensedCompaniesState>(
          builder: (context, state) {
            if (state is LicensedCompaniesLoaded) {
              return ListView.builder(
                itemCount: state.companies.length,
                itemBuilder: (context, index) {
                  final company = state.companies[index];
                  return ElevatedButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Text(company.id),
                        Text(company.name),
                        Text(company.accessUrl.toString()),
                      ],
                    ),
                  );
                },
              );
            } else if (state is LicensedCompaniesError) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
