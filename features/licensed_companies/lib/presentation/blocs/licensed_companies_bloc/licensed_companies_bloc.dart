import 'dart:async';

import 'package:core/core.dart';
import 'package:licensed_companies/entities.dart';
import 'package:licensed_companies/usecases.dart';

part 'licensed_companies_event.dart';
part 'licensed_companies_state.dart';

class LicensedCompaniesBloc
    extends Bloc<LicensedCompaniesEvent, LicensedCompaniesState> {
  final GetCompanies _getCompanies;
  final AddCompany _addCompany;
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
      final list = await _getCompanies();
      if (list != null && list.isNotEmpty) {
        companies = list;
        emit(LicensedCompaniesLoaded(companies));
      }
    } catch (e, s) {
      emit(LicensedCompaniesError(e.toString()));
      addError(e, s);
    }
  }

  FutureOr<void> _onCreatedCompanyEvent(
    CreatedCompanyEvent event,
    Emitter<LicensedCompaniesState> emit,
  ) async {
    if (state is LicensedCompaniesLoaded) {
      final companies = (state as LicensedCompaniesLoaded).companies;
      if (companies != null && companies.isNotEmpty) {
        emit(LicensedCompaniesCreatedInProgress());
        try {
          int id;
          id = companies.last.id + 1;
          final company = event.company.copyWith(id: id);
          await _addCompany(company);
          emit(LicensedCompaniesCreatedSuccess(company));
          add(FetchCompaniesEvent());
        } catch (e, s) {
          emit(LicensedCompaniesCreatedFailure(e.toString()));
          addError(e, s);
        }
      }
    }
  }

  FutureOr<void> _onUpdatedCompanyEvent(
    UpdatedCompanyEvent event,
    Emitter<LicensedCompaniesState> emit,
  ) async {
    emit(LicensedCompaniesUpdatedInProgress());
    try {
      await _addCompany(event.company);
      emit(
        LicensedCompaniesUpdatedSuccess(event.company),
      );
      add(FetchCompaniesEvent());
    } catch (e, s) {
      emit(LicensedCompaniesUpdatedFailure(e.toString()));
      addError(e, s);
    }
  }
}
