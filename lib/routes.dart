import 'package:flutter/widgets.dart';
import 'package:licensed_companies/domain/entities/licenced_company.dart';
import 'package:licensed_companies/presentation.dart';

Map<String, Widget Function(BuildContext)> get mentorRoutes => {
      '/licensed_companies': (context) => const LicensedCompaniesPage(),
      '/licensed_companie': (context) => LicensedCompanyPage(
            company:
                ModalRoute.of(context)!.settings.arguments as LicensedCompany?,
          ),
    };
