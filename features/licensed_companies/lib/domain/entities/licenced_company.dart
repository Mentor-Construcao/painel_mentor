import 'package:core/core.dart' show Equatable;
import 'package:core/firebase_cloud_firestore_model.dart';

class LicensedCompany extends Equatable with CloudFirestoreModel {
  final int id;
  final String name;
  final String accessUrl;
  final bool? exclued;

  const LicensedCompany({
    required this.id,
    required this.name,
    required this.accessUrl,
    required this.exclued,
  });

  LicensedCompany.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            name: json['nome'],
            accessUrl: json['link'],
            exclued: json['exclued']);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': name,
      'link': accessUrl,
      'exclued': exclued,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        accessUrl,
        exclued,
      ];
  LicensedCompany copyWith({
    int? id,
    String? name,
    String? accessUrl,
    bool? exclued,
  }) {
    return LicensedCompany(
      id: id ?? this.id,
      name: name ?? this.name,
      accessUrl: accessUrl ?? this.accessUrl,
      exclued: exclued ?? this.exclued,
    );
  }
}
