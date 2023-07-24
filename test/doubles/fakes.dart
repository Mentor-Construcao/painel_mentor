import 'package:painel_mentor/features/licensed_companies/domain/entities/licenced_company.dart';

LicensedCompany fakeCompany({
  int? id,
  String? name,
  String? url,
}) =>
    LicensedCompany(
      id: id ?? 1,
      name: name ?? 'name',
      accessUrl: url ?? 'accessUrl',
    );
