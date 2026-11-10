import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:gu_teknofest/features/landing/view/landing_view.dart';

part 'app_routes.g.dart';

/// Rota adresleri — tek yer.
abstract final class AppPaths {
  /// Genel sayfa.
  static const String landing = '/';
}

/// Genel sayfa (`/`). Menü öğeleri rota değiştirmez; bölüme kaydırır.
@TypedGoRoute<LandingRoute>(path: AppPaths.landing)
final class LandingRoute extends GoRouteData with $LandingRoute {
  /// Rota oluşturur.
  const LandingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LandingView();
}
