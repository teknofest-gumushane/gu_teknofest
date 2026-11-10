import 'dart:async';

import 'package:gu_teknofest/core/bootstrap/app_bootstrap.dart';
import 'package:gu_teknofest/core/bootstrap/tf_app.dart';
import 'package:gu_teknofest/core/error/app_error_handler.dart';

void main() {
  unawaited(
    runZonedGuarded(
      () => AppBootstrap.run(appBuilder: () => const TfApp()),
      AppErrorHandler.onZoneError,
    ),
  );
}
