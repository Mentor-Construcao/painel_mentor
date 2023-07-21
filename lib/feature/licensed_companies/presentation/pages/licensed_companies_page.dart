import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painel_mentor/entities/licenced_company.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/bloc/licensed_companies_bloc.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/bloc/licensed_companies_event.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/bloc/licensed_companies_state.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/pages/licensed_company_page.dart';
import 'package:painel_mentor/injection.dart';

class LicensedCompaniesPage extends StatefulWidget {
  const LicensedCompaniesPage({super.key});

  @override
  State<LicensedCompaniesPage> createState() => _LicensedCompaniesPageState();
}

class _LicensedCompaniesPageState extends State<LicensedCompaniesPage> {
  final LicensedCompaniesBloc bloc = sl<LicensedCompaniesBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LicensedCompaniesBloc>.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<LicensedCompaniesBloc, LicensedCompaniesState>(
            builder: (context, state) {
              String companiesTotal = state is LicensedCompaniesLoaded
                  ? '${state.companies?.length ?? 0}'
                  : '';
              return Text('Empresas Licenciadas: $companiesTotal');
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: BlocBuilder<LicensedCompaniesBloc, LicensedCompaniesState>(
            bloc: bloc,
            builder: (context, state) {
              if (state is LicensedCompaniesInital) {
                bloc.add(FetchCompaniesEvent());
              }
              if (state is LicensedCompaniesLoaded) {
                if (state.companies == null || state.companies!.isEmpty) {
                  return const Center(
                    child: Text('Não há empresas licenciadas.'),
                  );
                }
                state.companies!.sort((a, b) => a.id.compareTo(b.id));
                return ListView.builder(
                  itemCount: state.companies?.length,
                  itemBuilder: (context, index) {
                    final company = state.companies?[index];
                    return ElevatedButton(
                      onPressed: () => _onEditCompany(company),
                      child: Row(
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                company!.id.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              children: [
                                Text(company.name),
                                Text(company.accessUrl.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is LicensedCompaniesError) {
                return const Center(
                  child: Text('Ops, aconteceu algo errado!'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onAddCompany,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _onAddCompany() async {
    final LicensedCompany? company = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LicensedCompanyPage(),
      ),
    );
    if (company != null &&
        company.name.isNotEmpty &&
        company.accessUrl.isNotEmpty) {
      bloc.add(CreatedCompanyEvent(company));
    }
  }

  void _onEditCompany(LicensedCompany company) async {
    final LicensedCompany? editedCompany = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LicensedCompanyPage(
          company: company,
        ),
      ),
    );
    if (editedCompany != null) {
      if (editedCompany.name != company.name ||
          editedCompany.accessUrl != company.accessUrl) {
        bloc.add(UpdatedCompanyEvent(editedCompany));
      }
    }
  }
}
