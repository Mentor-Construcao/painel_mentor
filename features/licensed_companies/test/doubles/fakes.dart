import 'package:licensed_companies/entities.dart';

LicensedCompany fakeCompany({
  int? id,
  String? name,
  String? url,
}) =>
    LicensedCompany(
      id: id ?? 1,
      name: name ?? 'name',
      accessUrl: url ?? 'accessUrl',
      exclued: false,
      autoBackup: true,
    );
