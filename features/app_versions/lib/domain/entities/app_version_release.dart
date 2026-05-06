import 'package:core/core.dart' show Equatable;
import 'package:core/firebase_cloud_firestore_model.dart';

enum VersionBuildComparison {
  lower,
  equal,
}

class AppVersionRelease extends Equatable with CloudFirestoreModel {
  static const defaultTitle = 'Nova versão disponível';
  static const defaultDescription =
      'Atualize o aplicativo para acessar novas funcionalidades, melhorar o desempenho e garantir a segurança dos dados.';
  static const defaultAlertMessage =
      'Não atualizar, pode causar erros na sincronização e no uso do aplicativo.';

  final int buildNumber;
  final String title;
  final String description;
  final bool showAlertMessage;
  final String alertMessage;
  final bool mandatoryUpdate;
  final bool isActive;
  final String createdAt;

  const AppVersionRelease({
    required this.buildNumber,
    required this.title,
    required this.description,
    required this.showAlertMessage,
    required this.alertMessage,
    required this.mandatoryUpdate,
    required this.isActive,
    required this.createdAt,
  });

  AppVersionRelease.fromJson(Map<String, dynamic> json)
      : this(
          buildNumber: json['buildNumber'] ?? 0,
          title: json['title'] ?? '',
          description: json['description'] ?? '',
          showAlertMessage: json['showAlertMessage'] ?? false,
          alertMessage: json['alertMessage'] ?? '',
          mandatoryUpdate: json['mandatoryUpdate'] ?? false,
          isActive: json['isActive'] ?? false,
          createdAt: json['createdAt'] ?? '',
        );

  bool get hasAlertMessage =>
      showAlertMessage && alertMessage.trim().isNotEmpty;

  VersionBuildComparison compareWithRemoteBuild(int remoteBuildNumber) {
    if (buildNumber == remoteBuildNumber) {
      return VersionBuildComparison.equal;
    }
    return VersionBuildComparison.lower;
  }

  AppVersionRelease copyWith({
    int? buildNumber,
    String? title,
    String? description,
    bool? showAlertMessage,
    String? alertMessage,
    bool? mandatoryUpdate,
    bool? isActive,
    String? createdAt,
  }) {
    return AppVersionRelease(
      buildNumber: buildNumber ?? this.buildNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      showAlertMessage: showAlertMessage ?? this.showAlertMessage,
      alertMessage: alertMessage ?? this.alertMessage,
      mandatoryUpdate: mandatoryUpdate ?? this.mandatoryUpdate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'buildNumber': buildNumber,
      'title': title,
      'description': description,
      'showAlertMessage': showAlertMessage,
      'alertMessage': alertMessage,
      'mandatoryUpdate': mandatoryUpdate,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        buildNumber,
        title,
        description,
        showAlertMessage,
        alertMessage,
        mandatoryUpdate,
        isActive,
        createdAt,
      ];
}
