import 'package:core/core.dart' show Equatable;
import 'package:core/firebase_cloud_firestore_model.dart';

class AppVersionSettings extends Equatable with CloudFirestoreModel {
  final String googlePlayStoreUrl;
  final String appStoreUrl;

  const AppVersionSettings({
    required this.googlePlayStoreUrl,
    required this.appStoreUrl,
  });

  static const empty = AppVersionSettings(
    googlePlayStoreUrl: '',
    appStoreUrl: '',
  );

  AppVersionSettings.fromJson(Map<String, dynamic> json)
      : this(
          googlePlayStoreUrl:
              json['googlePlayStoreUrl'] ?? json['playStoreUrl'] ?? '',
          appStoreUrl: json['appStoreUrl'] ?? '',
        );

  AppVersionSettings copyWith({
    String? googlePlayStoreUrl,
    String? appStoreUrl,
  }) {
    return AppVersionSettings(
      googlePlayStoreUrl: googlePlayStoreUrl ?? this.googlePlayStoreUrl,
      appStoreUrl: appStoreUrl ?? this.appStoreUrl,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'googlePlayStoreUrl': googlePlayStoreUrl,
      'appStoreUrl': appStoreUrl,
    };
  }

  @override
  List<Object?> get props => [
        googlePlayStoreUrl,
        appStoreUrl,
      ];
}
