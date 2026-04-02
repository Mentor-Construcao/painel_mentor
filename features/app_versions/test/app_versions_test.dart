import 'package:flutter_test/flutter_test.dart';

import 'package:app_versions/app_versions.dart';

void main() {
  test('exports appVersionsInjection', () {
    expect(appVersionsInjection, isA<Function>());
  });
}
