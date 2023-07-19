import 'package:painel_mentor/services/cloud_firestore_service.dart';

class GetCompanies {
  final firestore = CloudFirestoreService();

  Future<List> call() async {
    return await firestore.getCollection();
  }
}
