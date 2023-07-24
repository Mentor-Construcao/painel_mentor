import 'package:equatable/equatable.dart';
import 'package:painel_mentor/entities/licenced_company.dart';

abstract class LicensedCompaniesState extends Equatable {}

class LicensedCompaniesInital extends LicensedCompaniesState {
  LicensedCompaniesInital();

  @override
  List<Object?> get props => [];
}

class LicensedCompaniesLoading extends LicensedCompaniesState {
  LicensedCompaniesLoading();

  @override
  List<Object?> get props => [];
}

class LicensedCompaniesError extends LicensedCompaniesState {
  final String? error;

  LicensedCompaniesError(this.error);
  @override
  List<Object?> get props => [];
}

class LicensedCompaniesLoaded extends LicensedCompaniesState {
  final List<LicensedCompany>? companies;

  LicensedCompaniesLoaded(this.companies);
  @override
  List<Object?> get props => [companies];
}

class LicensedCompaniesUpdatedInProgress extends LicensedCompaniesState {
  @override
  List<Object?> get props => [];
}

class LicensedCompaniesUpdatedSuccess extends LicensedCompaniesState {
  final LicensedCompany company;

  LicensedCompaniesUpdatedSuccess(this.company);
  @override
  List<Object?> get props => [company];
}

class LicensedCompaniesUpdatedFailure extends LicensedCompaniesError {
  LicensedCompaniesUpdatedFailure(super.error);

  @override
  List<Object?> get props => [];
}

class LicensedCompaniesCreatedInProgress extends LicensedCompaniesState {
  @override
  List<Object?> get props => [];
}

class LicensedCompaniesCreatedSuccess extends LicensedCompaniesState {
  final LicensedCompany company;

  LicensedCompaniesCreatedSuccess(this.company);

  @override
  List<Object?> get props => [company];
}

class LicensedCompaniesCreatedFailure extends LicensedCompaniesError {
  LicensedCompaniesCreatedFailure(super.error);

  @override
  List<Object?> get props => [];
}
