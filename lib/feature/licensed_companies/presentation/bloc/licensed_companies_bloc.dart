import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:painel_mentor/entities/licenced_company.dart';
import 'package:painel_mentor/feature/licensed_companies/domain/usecases/add_company.dart';
import 'package:painel_mentor/feature/licensed_companies/domain/usecases/get_companies.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/bloc/licensed_companies_event.dart';
import 'package:painel_mentor/feature/licensed_companies/presentation/bloc/licensed_companies_state.dart';

class LicensedCompaniesBloc
    extends Bloc<LicensedCompaniesEvent, LicensedCompaniesState> {
  final GetCompanies? _getCompanies;
  final AddCompany? _addCompany;
  LicensedCompaniesBloc(
    this._getCompanies,
    this._addCompany,
  ) : super(LicensedCompaniesInital()) {
    on<FetchCompaniesEvent>(_onFetchCompaniesEvent);
    on<CreatedCompanyEvent>(_onCreatedCompanyEvent);
    on<UpdatedCompanyEvent>(_onUpdatedCompanyEvent);
  }

  FutureOr<void> _onFetchCompaniesEvent(
    FetchCompaniesEvent event,
    Emitter<LicensedCompaniesState> emit,
  ) async {
    final List<LicensedCompany> companies;
    try {
      final list = await _getCompanies!();
      if (list != null && list.isNotEmpty) {
        companies = list;
        emit(LicensedCompaniesLoaded.fromLastState(state, companies));
      }
    } catch (e, s) {
      emit(LicensedCompaniesError.fromLastState(state));
      addError(e, s);
    }
  }

  FutureOr<void> _onCreatedCompanyEvent(
    CreatedCompanyEvent event,
    Emitter<LicensedCompaniesState> emit,
  ) async {
    emit(LicensedCompaniesCreatedInProgress.fromLastState(state));
    try {
      if (state.companies != null) {
        int id;
        id = state.companies!.last.id + 1;
        await _addCompany!(event.company.copyWith(id: id));
      }
      emit(
        LicensedCompaniesCreatedSuccess.fromLastState(
          state,
          companies: state.companies!,
        ),
      );
      add(FetchCompaniesEvent());
    } catch (e, s) {
      emit(LicensedCompaniesCreatedFailure.fromLastState(state));
      addError(e, s);
    }
  }

  FutureOr<void> _onUpdatedCompanyEvent(
    UpdatedCompanyEvent event,
    Emitter<LicensedCompaniesState> emit,
  ) async {
    emit(LicensedCompaniesUpdatedInProgress.fromLastState(state));
    try {
      await _addCompany!(event.company);
      emit(
        LicensedCompaniesUpdatedSuccess.fromLastState(
          state,
          companies: state.companies ?? [],
        ),
      );
      add(FetchCompaniesEvent());
    } catch (e, s) {
      emit(LicensedCompaniesUpdatedFailure.fromLastState(state));
      addError(e, s);
    }
  }
}
