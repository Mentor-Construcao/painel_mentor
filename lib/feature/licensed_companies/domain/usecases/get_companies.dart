import 'package:painel_mentor/entities/licenced_company.dart';
import 'package:painel_mentor/services/cloud_firestore_service.dart';

class GetCompanies {
  final CloudFirestoreService firestore;

  GetCompanies(this.firestore);

  Future<List<LicensedCompany>?> call() async {
    var query = await firestore.getCollection();
    final companies = <LicensedCompany>[];
    for (var doc in query.docs) {
      companies.add(doc.data() as LicensedCompany);
    }
    return companies;

    // return query;
  }
}
