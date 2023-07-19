import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:painel_mentor/entities/licenced_company.dart';

class CloudFirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference licensedCompaniesCollection;

  void initFirestore() {
    licensedCompaniesCollection = firestore
        .collection("licensed_companies")
        .withConverter<LicensedCompany>(
          fromFirestore: (snapshot, _) =>
              LicensedCompany.fromJson(snapshot.data()!),
          toFirestore: (document, _) => document.toJson(),
        );
  }

  Future<List> getCollection() async {
    return (await licensedCompaniesCollection.get()).docs;
  }

  Future<void> setCompany(LicensedCompany company) async {
    return await licensedCompaniesCollection.doc(company.id).set(company);
  }

  Future<void> deleteCompany(LicensedCompany company) async {
    return await licensedCompaniesCollection.doc(company.id).delete();
  }
}
