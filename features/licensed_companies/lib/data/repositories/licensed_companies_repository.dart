import 'package:licensed_companies/data/data_access/licensed_companies_firebase_cloud_data.dart';
import 'package:licensed_companies/domain/entities/licenced_company.dart';
import 'package:licensed_companies/domain/repositories/i_licenced_companies_repository.dart';

class LicensedCompaniesRepository implements ILicencedCompaniesRepository {
  final LicensedCompaniesFirebaseCloudData licencedCompaniesFirebaseCloudData;

  LicensedCompaniesRepository(this.licencedCompaniesFirebaseCloudData);
  @override
  Future<void> add(LicensedCompany licensedCompany) {
    return licencedCompaniesFirebaseCloudData.add(
        licensedCompany, licensedCompany.id.toString());
  }

  @override
  Future<List<LicensedCompany>> getAll() {
    return licencedCompaniesFirebaseCloudData.getAll();
  }
}
