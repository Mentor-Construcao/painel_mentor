import 'package:equatable/equatable.dart';
import 'package:painel_mentor/entities/licenced_company.dart';

abstract class LicensedCompaniesState extends Equatable {
  final List<LicensedCompany>? companies;
  const LicensedCompaniesState({this.companies});
  LicensedCompaniesState.fromLastState(
    LicensedCompaniesState lastState, {
    List<LicensedCompany>? companies,
  }) : companies = companies ?? lastState.companies;
}

class LicensedCompaniesInital extends LicensedCompaniesState {
  LicensedCompaniesInital() : super(companies: []);

  @override
  List<Object?> get props => [];
}

class LicensedCompaniesLoading extends LicensedCompaniesState {
  LicensedCompaniesLoading.fromLastState(super.lastState)
      : super.fromLastState();

  @override
  List<Object?> get props => [];
}

class LicensedCompaniesError extends LicensedCompaniesState {
  LicensedCompaniesError.fromLastState(super.lastState) : super.fromLastState();
  @override
  List<Object?> get props => [];
}

class LicensedCompaniesLoaded extends LicensedCompaniesState {
  LicensedCompaniesLoaded.fromLastState(
    super.lastState,
    List<LicensedCompany> companies,
  ) : super.fromLastState(
          companies: companies,
        );
  @override
  List<Object?> get props => [companies];
}

class LicensedCompaniesUpdatedInProgress extends LicensedCompaniesState {
  LicensedCompaniesUpdatedInProgress.fromLastState(super.lastState)
      : super.fromLastState();

  @override
  List<Object?> get props => [];
}

class LicensedCompaniesUpdatedSuccess extends LicensedCompaniesState {
  LicensedCompaniesUpdatedSuccess.fromLastState(
    super.lastState, {
    required List<LicensedCompany> companies,
  }) : super.fromLastState(
          companies: companies,
        );
  @override
  List<Object?> get props => [];
}

class LicensedCompaniesUpdatedFailure extends LicensedCompaniesState {
  LicensedCompaniesUpdatedFailure.fromLastState(super.lastState)
      : super.fromLastState();
  @override
  List<Object?> get props => [];
}

class LicensedCompaniesCreatedInProgress extends LicensedCompaniesState {
  LicensedCompaniesCreatedInProgress.fromLastState(super.lastState)
      : super.fromLastState();
  @override
  List<Object?> get props => [];
}

class LicensedCompaniesCreatedSuccess extends LicensedCompaniesState {
  LicensedCompaniesCreatedSuccess.fromLastState(super.lastState,
      {required List<LicensedCompany> companies})
      : super.fromLastState(
          companies: companies,
        );
  @override
  List<Object?> get props => [];
}

class LicensedCompaniesCreatedFailure extends LicensedCompaniesState {
  LicensedCompaniesCreatedFailure.fromLastState(super.lastState)
      : super.fromLastState();
  @override
  List<Object?> get props => [];
}
