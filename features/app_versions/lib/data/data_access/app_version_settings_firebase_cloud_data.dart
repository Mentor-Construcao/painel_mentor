import 'package:app_versions/entities.dart';
import 'package:core/firebase_cloud_firestore.dart';

class AppVersionSettingsFirebaseCloudData
    extends CloudFirestoreDataAccessBase<AppVersionSettings>
    implements ICloudFirestoreDataAcess<AppVersionSettings> {
  static const String _collectionName = 'app_versions_settings';
  static const String _documentName = 'default';

  @override
  String get collectionName => _collectionName;

  @override
  AppVersionSettings fromJson(Map<String, dynamic> json) {
    return AppVersionSettings.fromJson(json);
  }

  late final document = collection.doc(_documentName);

  Future<AppVersionSettings> get() async {
    final snapshot = await document.get();
    if (!snapshot.exists) {
      return AppVersionSettings.empty;
    }
    return snapshot.data() ?? AppVersionSettings.empty;
  }

  Future<void> put(AppVersionSettings settings) async {
    await add(settings, _documentName);
  }
}
