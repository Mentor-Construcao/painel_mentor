import 'package:core/injections_service/injection.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/licenced_company.dart';
import 'package:core/core.dart';

import '../blocs/blocs.dart';

class LicensedCompaniesPage extends StatefulWidget {
  const LicensedCompaniesPage({super.key});

  @override
  State<LicensedCompaniesPage> createState() => _LicensedCompaniesPageState();
}

class _LicensedCompaniesPageState extends State<LicensedCompaniesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LicensedCompaniesBloc>.value(
      value: sl<LicensedCompaniesBloc>(),
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
            builder: (context, state) {
              if (state is LicensedCompaniesInital) {
                context
                    .read<LicensedCompaniesBloc>()
                    .add(FetchCompaniesEvent());
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
                      onPressed: () => _onEditCompany(context, company),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                company!.id.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(child: Text(company.name)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        company.accessUrl.toString(),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
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
    final LicensedCompany? company = await Navigator.pushNamed(
      context,
      '/licensed_companie',
    );
    if (company != null &&
        company.name.isNotEmpty &&
        company.accessUrl.isNotEmpty &&
        mounted) {
      context.read<LicensedCompaniesBloc>().add(CreatedCompanyEvent(company));
    }
  }

  void _onEditCompany(BuildContext context, LicensedCompany company) async {
    await Navigator.of(context).pushNamed(
      '/licensed_companie',
    );
    //     await Navigator.pushNamed<LicensedCompany?>(
    //   context,
    //   '/licensed_companie',
    // );

    // if (editedCompany != null) {
    //   if (editedCompany.name != company.name ||
    //       editedCompany.accessUrl != company.accessUrl && mounted) {
    //     if (mounted) {
    //       context
    //           .read<LicensedCompaniesBloc>()
    //           .add(UpdatedCompanyEvent(editedCompany));
    //     }
    //   }
    // }
  }
}
