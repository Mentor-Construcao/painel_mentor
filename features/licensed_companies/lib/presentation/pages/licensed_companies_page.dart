import 'package:core/injections_service/injection.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/licenced_company.dart';
import 'package:core/core.dart';

import '../blocs/blocs.dart';

class LicensedCompaniesPage extends StatelessWidget {
  const LicensedCompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LicensedCompaniesBloc>.value(
      value: sl<LicensedCompaniesBloc>()..add(InitializedCompaniesEvent()),
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
                    .add(InitializedCompaniesEvent());
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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
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
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                            child: SelectableText(
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
          onPressed: () => _onAddCompany(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _onAddCompany(
    BuildContext context,
  ) async {
    await Navigator.of(context).pushNamed(
      '/licensed_companie',
    );
  }

  void _onEditCompany(BuildContext context, LicensedCompany company) async {
    await Navigator.of(context).pushNamed(
      '/licensed_companie',
      arguments: company,
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
