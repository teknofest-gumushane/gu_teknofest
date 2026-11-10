import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:gu_teknofest/product/navigation/not_found_view.dart';
import 'package:gu_teknofest/product/navigation/routes/app_routes.dart';

/// Yönlendirici. Rotalar `routes/` altında tanımlanır; yeni rota dosyası
/// eklenince [routes] listesine onun `$appRoutes`'u eklenir.
abstract final class AppRouter {
  /// Tüm rotalar.
  static List<RouteBase> get routes => <RouteBase>[...$appRoutes];

  /// Yönlendiriciyi kurar. [initialLocation] testler içindir.
  static GoRouter create({String initialLocation = AppPaths.landing}) =>
      GoRouter(
        initialLocation: initialLocation,
        routes: routes,
        errorBuilder: (context, state) => const NotFoundView(),
        debugLogDiagnostics: kDebugMode,
      );
}
