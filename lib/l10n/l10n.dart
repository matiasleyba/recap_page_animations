import 'package:flutter/widgets.dart';
import 'package:recap_app/l10n/gen/app_localizations.dart';

export 'package:recap_app/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
