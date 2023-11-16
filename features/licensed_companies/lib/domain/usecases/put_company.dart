import 'package:licensed_companies/domain/repositories/i_licenced_companies_repository.dart';
import 'package:licensed_companies/entities.dart';

class PutCompany {
  Stream<LicensedCompany> get onLicensedCompanyPut =>
      _licencedCompaniesRepository.onLicensedCompanyPut;

  final ILicencedCompaniesRepository _licencedCompaniesRepository;

  PutCompany(this._licencedCompaniesRepository);

  Future<void> call(LicensedCompany company) async {
    return await _licencedCompaniesRepository.put(company);
  }
}
