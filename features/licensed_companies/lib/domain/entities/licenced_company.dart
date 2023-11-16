import 'package:core/core.dart' show Equatable;
import 'package:core/firebase_cloud_firestore_model.dart';

class LicensedCompany extends Equatable with CloudFirestoreModel {
  final int id;
  final String name;
  final String accessUrl;
  final bool? exclued;
  final bool? autoBackup;

  const LicensedCompany({
    required this.id,
    required this.name,
    required this.accessUrl,
    required this.exclued,
    required this.autoBackup,
  });

  LicensedCompany.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['nome'],
          accessUrl: json['link'],
          exclued: json['exclued'],
          autoBackup: json['autoBackup'],
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': name,
      'link': accessUrl,
      'exclued': exclued,
      'autoBackup': autoBackup,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        accessUrl,
        exclued,
        autoBackup,
      ];
  LicensedCompany copyWith({
    int? id,
    String? name,
    String? accessUrl,
    bool? exclued,
    bool? autoBackup,
  }) {
    return LicensedCompany(
      id: id ?? this.id,
      name: name ?? this.name,
      accessUrl: accessUrl ?? this.accessUrl,
      exclued: exclued ?? this.exclued,
      autoBackup: autoBackup ?? this.autoBackup,
    );
  }
}
