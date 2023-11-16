import 'dart:async';

import 'package:licensed_companies/data/data_access/licensed_companies_firebase_cloud_data.dart';
import 'package:licensed_companies/domain/entities/licenced_company.dart';
import 'package:licensed_companies/domain/repositories/i_licenced_companies_repository.dart';

class LicensedCompaniesRepository implements ILicencedCompaniesRepository {
  final LicensedCompaniesFirebaseCloudData licencedCompaniesFirebaseCloudData;

  final StreamController<LicensedCompany> _onLicensedCompanyPut =
      StreamController.broadcast();

  LicensedCompaniesRepository(this.licencedCompaniesFirebaseCloudData);
  @override
  Future<void> put(LicensedCompany licensedCompany) async {
    await licencedCompaniesFirebaseCloudData.add(
      licensedCompany,
      '${licensedCompany.id} - ${licensedCompany.name}',
    );
    _onLicensedCompanyPut.add(licensedCompany);
  }

  @override
  Future<List<LicensedCompany>> getAll() {
    return licencedCompaniesFirebaseCloudData.getAll();
  }

  @override
  Stream<LicensedCompany> get onLicensedCompanyPut =>
      _onLicensedCompanyPut.stream;
}
