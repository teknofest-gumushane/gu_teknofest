import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gu_teknofest/features/landing/view/landing_section_id.dart';
import 'package:gu_teknofest/features/landing/view/landing_view.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/extension/build_context_x.dart';
import 'package:gu_teknofest/product/theme/tf_motion.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:material_ui/material_ui.dart';

/// [LandingView]'in davranışı: kaydırma, bölüm anahtarları, üst barın
/// küçülmesi ve çekmece menü.
mixin LandingViewMixin on ConsumerState<LandingView> {
  /// Sayfanın kaydırma denetleyicisi.
  final ScrollController scrollController = ScrollController();

  /// Çekmeceyi açıp kapatmak için.
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Her bölümün anahtarı; menü ilgili bölüme bununla kaydırır.
  final Map<LandingSectionId, GlobalKey> sectionKeys = {
    for (final id in LandingSectionId.values)
      id: GlobalKey(debugLabel: id.name),
  };

  /// Sayfa kaydırıldı mı (üst bar küçülür ve gölge alır).
  final ValueNotifier<bool> isScrolled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    isScrolled.dispose();
    super.dispose();
  }

  void _onScroll() {
    isScrolled.value = scrollController.offset > TfSizes.headerShrinkOffset;
  }

  /// [id] bölümünü görünür alana kaydırır.
  Future<void> scrollToSection(LandingSectionId id) async {
    final target = sectionKeys[id]?.currentContext;
    if (target == null) return;
    await Scrollable.ensureVisible(
      target,
      duration: context.tf.duration(TfMotion.scroll),
      curve: TfMotion.emphasized,
    );
  }

  /// Çekmece menüyü açar.
  void openMenu() => scaffoldKey.currentState?.openEndDrawer();

  /// Menüden bir bölüm seçildi: çekmece açıksa kapanır, sonra kaydırılır.
  Future<void> onSectionSelected(LandingSectionId id) async {
    _closeMenuIfOpen();
    await scrollToSection(id);
  }

  /// "Takıma Katıl" basıldı. Form yazılana kadar "yakında" bildirimi gösterir.
  void onJoinPressed() {
    _closeMenuIfOpen();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.joinComingSoon)));
  }

  void _closeMenuIfOpen() {
    final scaffold = scaffoldKey.currentState;
    if (scaffold != null && scaffold.isEndDrawerOpen) {
      scaffold.closeEndDrawer();
    }
  }
}
