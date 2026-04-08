import 'package:app_versions/entities.dart';
import 'package:core/firebase_cloud_firestore.dart';

class AppVersionsFirebaseCloudData
    extends CloudFirestoreDataAccessBase<AppVersionRelease>
    implements ICloudFirestoreDataAcess<AppVersionRelease> {
  @override
  String get collectionName => 'app_versions';

  @override
  AppVersionRelease fromJson(Map<String, dynamic> json) {
    return AppVersionRelease.fromJson(json);
  }
}
