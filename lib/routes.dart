import 'package:app_versions/presentation.dart';
import 'package:backups/presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:app_versions/entities.dart';
import 'package:licensed_companies/domain/entities/licenced_company.dart';
import 'package:licensed_companies/presentation.dart';
import 'package:painel_mentor/home_page.dart';

Map<String, Widget Function(BuildContext)> get mentorRoutes => {
      '/app_versions': (context) => const AppVersionsPage(),
      '/app_version': (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as AppVersionPageArgs;
        return AppVersionPage(
          release: args.release,
          settings: args.settings,
          existingBuildNumbers: args.existingBuildNumbers,
        );
      },
      '/app_version_settings': (context) => AppVersionSettingsPage(
            settings: ModalRoute.of(context)!.settings.arguments
                    as AppVersionSettings? ??
                AppVersionSettings.empty,
          ),
      '/licensed_companies': (context) => const LicensedCompaniesPage(),
      '/licensed_companie': (context) => LicensedCompanyPage(
            company:
                ModalRoute.of(context)!.settings.arguments as LicensedCompany?,
          ),
      '/home': (context) => const HomePage(),
      '/backup': (context) => BackupPage(),
    };
