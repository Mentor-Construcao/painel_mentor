import 'package:licensed_companies/domain/repositories/i_licenced_companies_repository.dart';
import 'package:licensed_companies/entities.dart';

class GetCompanies {
  final ILicencedCompaniesRepository _licencedCompaniesRepository;

  GetCompanies(this._licencedCompaniesRepository);

  Future<List<LicensedCompany>?> call() async {
    return _licencedCompaniesRepository.getAll();
  }
}
