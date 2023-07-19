import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/bloc/licensed_companies_event.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/bloc/licensed_companies_state.dart';

class LicensedCompaniesBloc
    extends Bloc<LicensedCompaniesEvent, LicensedCompaniesState> {
  LicensedCompaniesBloc() : super(LicensedCompaniesInital()) {
    on<FetchCompaniesEvent>(_onFetchCompaniesEvent);
    on<CreatedCompanyEvent>(_onCreatedCompanyEvent);
    on<UpdatedCompanyEvent>(_onUpdatedCompanyEvent);
  }

  FutureOr<void> _onFetchCompaniesEvent(
      FetchCompaniesEvent event, Emitter<LicensedCompaniesState> emit) {}

  FutureOr<void> _onCreatedCompanyEvent(
      CreatedCompanyEvent event, Emitter<LicensedCompaniesState> emit) {}

  FutureOr<void> _onUpdatedCompanyEvent(
      UpdatedCompanyEvent event, Emitter<LicensedCompaniesState> emit) {}
}
