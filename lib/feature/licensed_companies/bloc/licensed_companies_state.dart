import 'package:equatable/equatable.dart';
import 'package:painel_mentor/entities/licenced_company.dart';

abstract class LicensedCompaniesState extends Equatable {}

class LicensedCompaniesInital extends LicensedCompaniesState {
  @override
  List<Object?> get props => [];
}

class LicensedCompaniesLoading extends LicensedCompaniesState {
  @override
  List<Object?> get props => [];
}

class LicensedCompaniesError extends LicensedCompaniesState {
  final String error;

  LicensedCompaniesError(this.error);
  @override
  List<Object?> get props => [error];
}

class LicensedCompaniesLoaded extends LicensedCompaniesState {
  final List<LicensedCompany> companies;

  LicensedCompaniesLoaded(this.companies);
  @override
  List<Object?> get props => [companies];
}

class LicensedCompaniesUpdated extends LicensedCompaniesState {
  final LicensedCompany company;

  LicensedCompaniesUpdated(this.company);
  @override
  List<Object?> get props => [company];
}

class LicensedCompaniesCreated extends LicensedCompaniesState {
  final LicensedCompany company;

  LicensedCompaniesCreated(this.company);
  @override
  List<Object?> get props => [company];
}
