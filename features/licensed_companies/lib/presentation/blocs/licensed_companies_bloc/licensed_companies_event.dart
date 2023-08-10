part of 'licensed_companies_bloc.dart';

abstract class LicensedCompaniesEvent extends Equatable {}

class FetchCompaniesEvent extends LicensedCompaniesEvent {
  @override
  List<Object?> get props => [];
}

class CreatedCompanyEvent extends LicensedCompaniesEvent {
  final LicensedCompany company;

  CreatedCompanyEvent(this.company);
  @override
  List<Object?> get props => [company];
}

class UpdatedCompanyEvent extends LicensedCompaniesEvent {
  final LicensedCompany company;

  UpdatedCompanyEvent(this.company);
  @override
  List<Object?> get props => [company];
}
