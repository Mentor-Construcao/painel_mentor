import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:licensed_companies/entities.dart';
import 'package:licensed_companies/presentation/blocs/blocs.dart';

import '../doubles/fakes.dart';
import '../doubles/use_cases.mocks.dart';

late LicensedCompaniesBloc bloc;
final _addCompanies = MockAddCompany();
final _getCompanies = MockGetCompanies();

void main() {
  var companies = [fakeCompany(), fakeCompany(id: 2)];
  setUp(() {
    bloc = LicensedCompaniesBloc(
      _getCompanies,
      _addCompanies,
    );
  });
  blocTest<LicensedCompaniesBloc, LicensedCompaniesState>(
    'emite estado de sucesso após carregamento das informações',
    build: () => bloc,
    setUp: () {
      when(_getCompanies.call())
          .thenAnswer((realInvocation) async => companies);
    },
    act: (bloc) => bloc.add(InitializedCompaniesEvent()),
    expect: () => [LicensedCompaniesLoaded(companies)],
  );

  blocTest(
    'emite estado de sucesso após inserir novo licenciado',
    build: () => bloc,
    setUp: () => _setupCreateCompany(companies),
    act: (bloc) {
      bloc.add(InitializedCompaniesEvent());
      bloc.add(CreatedCompanyEvent(fakeCompany(id: 1000)));
    },
    expect: () => [
      LicensedCompaniesLoaded(companies),
      LicensedCompaniesCreatedInProgress(),
      LicensedCompaniesCreatedSuccess(fakeCompany(id: 3)),
      LicensedCompaniesLoaded(companies),
    ],
  );
  blocTest(
    'emite estado de sucesso após editar novo licenciado',
    build: () => bloc,
    setUp: () => _setupUpdateCompany(companies),
    act: (bloc) => bloc
        .add(UpdatedCompanyEvent(fakeCompany(id: 1000, name: 'nome alterado'))),
    expect: () => [
      LicensedCompaniesUpdatedInProgress(),
      LicensedCompaniesUpdatedSuccess(fakeCompany(
        id: 1000,
        name: 'nome alterado',
      )),
      LicensedCompaniesLoaded(companies),
    ],
  );
}

void _setupCreateCompany(List<LicensedCompany> companies) async {
  when(_getCompanies.call()).thenAnswer((realInvocation) async => companies);
  when(_addCompanies.call(fakeCompany())).thenAnswer((realInvocation) async {});
}

void _setupUpdateCompany(List<LicensedCompany> companies) {
  when(_getCompanies.call()).thenAnswer((realInvocation) async => companies);
  when(_addCompanies.call(fakeCompany(id: 1000, name: 'nome alterado')))
      .thenAnswer((realInvocation) async {});
}
