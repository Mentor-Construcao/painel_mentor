import 'package:app_versions/entities.dart';
import 'package:app_versions/usecases.dart';
import 'package:mockito/mockito.dart';

class MockGetAppVersions extends Mock implements GetAppVersions {
  @override
  Future<List<AppVersionRelease>> call() =>
      super.noSuchMethod(
        Invocation.method(#call, []),
        returnValue: Future.value(<AppVersionRelease>[]),
        returnValueForMissingStub: Future.value(<AppVersionRelease>[]),
      ) as Future<List<AppVersionRelease>>;
}

class MockPutAppVersion extends Mock implements PutAppVersion {
  @override
  Future<void> call(AppVersionRelease release) =>
      super.noSuchMethod(
        Invocation.method(#call, [release]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      ) as Future<void>;
}

class MockGetAppVersionSettings extends Mock
    implements GetAppVersionSettings {
  @override
  Future<AppVersionSettings> call() =>
      super.noSuchMethod(
        Invocation.method(#call, []),
        returnValue: Future.value(AppVersionSettings.empty),
        returnValueForMissingStub: Future.value(AppVersionSettings.empty),
      ) as Future<AppVersionSettings>;
}

class MockPutAppVersionSettings extends Mock
    implements PutAppVersionSettings {
  @override
  Future<void> call(AppVersionSettings settings) =>
      super.noSuchMethod(
        Invocation.method(#call, [settings]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      ) as Future<void>;
}
