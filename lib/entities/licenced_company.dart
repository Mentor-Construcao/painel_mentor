class LicensedCompany {
  final String id;
  final String name;
  final String accessUrl;

  LicensedCompany({
    required this.id,
    required this.name,
    required this.accessUrl,
  });

  LicensedCompany copyWith({
    String? id,
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
          name: json['name'],
          accessUrl: json['accessUrl'],
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accessUrl': accessUrl,
    };
  }
}
