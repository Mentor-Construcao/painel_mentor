import 'package:equatable/equatable.dart';

class LicensedCompany extends Equatable {
  final int id;
  final String name;
  final String accessUrl;

  const LicensedCompany({
    required this.id,
    required this.name,
    required this.accessUrl,
  });

  LicensedCompany copyWith({
    int? id,
    String? name,
    String? accessUrl,
  }) {
    return LicensedCompany(
      id: id ?? this.id,
      name: name ?? this.name,
      accessUrl: accessUrl ?? this.accessUrl,
    );
  }

  LicensedCompany.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['nome'],
          accessUrl: json['link'],
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': name,
      'link': accessUrl,
    };
  }

  @override
  List<Object?> get props => [id, name, accessUrl];
}
