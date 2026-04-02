import 'package:app_versions/injection.dart';
import 'package:backups/injections.dart';
import 'package:licensed_companies/injection.dart';

Future<void> initInjection() async {
  appVersionsInjection();
  licensedCompaniesInjection();
  backupInjections();
}
