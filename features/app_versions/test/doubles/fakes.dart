import 'package:app_versions/entities.dart';

AppVersionRelease fakeRelease({
  int? buildNumber,
  String? title,
  String? description,
  bool? showAlertMessage,
  String? alertMessage,
  bool? mandatoryUpdate,
  bool? isActive,
  String? createdAt,
}) =>
    AppVersionRelease(
      buildNumber: buildNumber ?? 1,
      title: title ?? 'Versao',
      description: description ?? 'Descricao',
      showAlertMessage: showAlertMessage ?? false,
      alertMessage: alertMessage ?? '',
      mandatoryUpdate: mandatoryUpdate ?? false,
      isActive: isActive ?? false,
      createdAt: createdAt ?? '2026-04-02T00:00:00',
    );

AppVersionSettings fakeSettings({
  String? googlePlayStoreUrl,
  String? appStoreUrl,
}) =>
    AppVersionSettings(
      googlePlayStoreUrl:
          googlePlayStoreUrl ?? 'https://play.google.com/store/apps/details?id=app',
      appStoreUrl: appStoreUrl ?? 'https://apps.apple.com/app/id123456',
    );
