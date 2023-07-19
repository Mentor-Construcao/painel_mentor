import 'package:equatable/equatable.dart';
import 'package:painel_mentor/entities/licenced_company.dart';

abstract class LicensedComapniesState extends Equatable {}

class LicensedComapniesInital extends LicensedComapniesState {
  @override
  List<Object?> get props => [];
}

class LicensedComapniesLoading extends LicensedComapniesState {
  @override
  List<Object?> get props => [];
}

class LicensedComapniesError extends LicensedComapniesState {
  @override
  List<Object?> get props => [];
}

class LicensedComapniesLoaded extends LicensedComapniesState {
  final List<LicensedCompany> companies;

  LicensedComapniesLoaded(this.companies);
  @override
  List<Object?> get props => [companies];
}

class LicensedComapniesUpdated extends LicensedComapniesState {
  final LicensedCompany company;

  LicensedComapniesUpdated(this.company);
  @override
  List<Object?> get props => [company];
}
