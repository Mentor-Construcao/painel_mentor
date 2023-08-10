import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloud_firestore_model.dart';
import 'i_cloud_firestore_data_acess.dart';

abstract class CloudFirestoreDataAccessBase<E extends CloudFirestoreModel>
    implements ICloudFirestoreDataAcess<E> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  E fromJson(Map<String, dynamic> json);

  String get collectionName;

  Map<String, dynamic> toJson(E model) => model.toJson();

  late CollectionReference<E> collection =
      firestore.collection(collectionName).withConverter<E>(
            fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson(),
          );

  @override
  Future<List<E>> getAll() async {
    var snapshot = await collection.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  @override
  Future<void> add(E model, String doc) async {
    return await collection.doc(doc).set(model);
  }
}
