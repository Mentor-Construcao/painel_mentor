import 'package:flutter/widgets.dart';
import 'package:licensed_companies/presentation.dart';

Map<String, Widget Function(BuildContext)> get mentorRoutes => {
      '/licensed_companies': (context) => const LicensedCompaniesPage(),
      '/licensed_companie': (context) => const LicensedCompanyPage(),
    };
