import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gu_teknofest/core/session/session_state.dart';
import 'package:gu_teknofest/core/session/session_view_model.dart';

/// `ConsumerState` içinde uygulama geneli state'e kısa erişim.
mixin AppProviderMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// Oturum (izlenir).
  SessionState get session => ref.watch(sessionViewModelProvider);

  /// Yönetici girişi var mı (izlenir).
  bool get isSignedIn =>
      ref.watch(sessionViewModelProvider.select((s) => s.isSignedIn));

  /// Oturum view model'i (izlenmez; çağrı için).
  SessionViewModel get sessionNotifier =>
      ref.read(sessionViewModelProvider.notifier);
}

/// `ConsumerWidget` içinde aynı erişim.
mixin AppProviderStateMixin on ConsumerWidget {
  /// Oturum (izlenir).
  SessionState sessionOf(WidgetRef ref) => ref.watch(sessionViewModelProvider);
}
