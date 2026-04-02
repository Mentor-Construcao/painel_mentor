import 'package:core/core.dart' show Equatable;
import 'package:core/firebase_cloud_firestore_model.dart';

class AppVersionSettings extends Equatable with CloudFirestoreModel {
  final String playStoreUrl;
  final String appStoreUrl;

  const AppVersionSettings({
    required this.playStoreUrl,
    required this.appStoreUrl,
  });

  static const empty = AppVersionSettings(
    playStoreUrl: '',
    appStoreUrl: '',
  );

  AppVersionSettings.fromJson(Map<String, dynamic> json)
      : this(
          playStoreUrl: json['playStoreUrl'] ?? '',
          appStoreUrl: json['appStoreUrl'] ?? '',
        );

  AppVersionSettings copyWith({
    String? playStoreUrl,
    String? appStoreUrl,
  }) {
    return AppVersionSettings(
      playStoreUrl: playStoreUrl ?? this.playStoreUrl,
      appStoreUrl: appStoreUrl ?? this.appStoreUrl,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'playStoreUrl': playStoreUrl,
      'appStoreUrl': appStoreUrl,
    };
  }

  @override
  List<Object?> get props => [
        playStoreUrl,
        appStoreUrl,
      ];
}
