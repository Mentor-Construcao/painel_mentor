import 'package:licensed_companies/entities.dart';

abstract class ILicencedCompaniesRepository {
  Future<List<LicensedCompany>> getAll();

  Future<void> add(LicensedCompany licensedCompany);
}
