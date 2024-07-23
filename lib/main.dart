import 'dart:async';

import 'package:money_accountant/src/core/utils/refined_logger.dart';
import 'package:money_accountant/src/feature/app/logic/app_runner.dart';

void main() {
  runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    );
}
