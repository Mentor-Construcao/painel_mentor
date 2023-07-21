import 'package:get_it/get_it.dart';
import 'package:painel_mentor/feature/licensed_companies/domain/usecases/add_company.dart';
import 'package:painel_mentor/feature/licensed_companies/domain/usecases/get_companies.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/bloc/licensed_companies_bloc.dart';
import 'package:painel_mentor/services/cloud_firestore_service.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  sl.registerSingleton<CloudFirestoreService>(CloudFirestoreService());
  sl.registerSingleton<GetCompanies>(GetCompanies(sl<CloudFirestoreService>()));
  sl.registerSingleton<AddCompany>(AddCompany(sl<CloudFirestoreService>()));
  sl.registerSingleton<LicensedCompaniesBloc>(
    LicensedCompaniesBloc(
      sl<GetCompanies>(),
      sl<AddCompany>(),
    ),
  );
}
