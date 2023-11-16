import 'package:core/injections_service/injection.dart';
import 'package:licensed_companies/domain/repositories/i_licenced_companies_repository.dart';
import 'data/data.dart';
import 'presentation/blocs/blocs.dart';
import 'usecases.dart';

void licensedCompaniesInjection() {
  _repositories();
  _usesCases();
  _blocs();
}

void _blocs() {
  sl.registerSingleton<LicensedCompaniesBloc>(
    LicensedCompaniesBloc(
      sl<GetCompanies>(),
      sl<PutCompany>(),
    ),
  );
}

void _usesCases() {
  sl.registerSingleton<GetCompanies>(
    GetCompanies(
      sl<ILicencedCompaniesRepository>(),
    ),
  );
  sl.registerSingleton<PutCompany>(
    PutCompany(
      sl<ILicencedCompaniesRepository>(),
    ),
  );
}

void _repositories() {
  sl.registerFactory<ILicencedCompaniesRepository>(
    () => LicensedCompaniesRepository(
      LicensedCompaniesFirebaseCloudData(),
    ),
  );
}
