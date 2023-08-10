import 'package:licensed_companies/domain/repositories/i_licenced_companies_repository.dart';
import 'package:licensed_companies/entities.dart';

class AddCompany {
  final ILicencedCompaniesRepository _licencedCompaniesRepository;

  AddCompany(this._licencedCompaniesRepository);

  Future<void> call(LicensedCompany company) async {
    return await _licencedCompaniesRepository.add(company);
  }
}
