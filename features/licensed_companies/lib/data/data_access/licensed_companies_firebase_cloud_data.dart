import 'package:core/firebase_cloud_firestore.dart';
import 'package:licensed_companies/entities.dart';

class LicensedCompaniesFirebaseCloudData
    extends CloudFirestoreDataAccessBase<LicensedCompany>
    implements ICloudFirestoreDataAcess<LicensedCompany> {
  @override
  String get collectionName => 'licenciados';

  @override
  LicensedCompany fromJson(Map<String, dynamic> json) {
    return LicensedCompany.fromJson(json);
  }
}
