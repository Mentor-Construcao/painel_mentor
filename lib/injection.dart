import 'package:backups/injections.dart';
import 'package:licensed_companies/injection.dart';

Future<void> initInjection() async {
  licensedCompaniesInjection();
  backupInjections();
}
