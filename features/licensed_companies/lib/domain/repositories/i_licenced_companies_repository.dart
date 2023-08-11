import 'package:licensed_companies/entities.dart';

abstract class ILicencedCompaniesRepository {
  Stream<LicensedCompany> get onLicensedCompanyPut;
  Future<List<LicensedCompany>> getAll();

  Future<void> put(LicensedCompany licensedCompany);
}
