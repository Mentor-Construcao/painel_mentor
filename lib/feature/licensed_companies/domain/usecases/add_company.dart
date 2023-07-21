import 'package:painel_mentor/entities/licenced_company.dart';
import 'package:painel_mentor/services/cloud_firestore_service.dart';

class AddCompany {
  final CloudFirestoreService firestore;

  AddCompany(this.firestore);

  Future<void> call(LicensedCompany company) async {
    return await firestore.setCompany(company);
  }
}
