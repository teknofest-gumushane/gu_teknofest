import 'package:gu_teknofest/core/session/session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_view_model.g.dart';

/// Oturumun tek sahibi. Admin girişi yazılınca (auth feature) giriş ve çıkış
/// burada işlenir; şimdilik herkes ziyaretçidir.
@Riverpod(keepAlive: true)
final class SessionViewModel extends _$SessionViewModel {
  @override
  SessionState build() => const SessionState();

  /// Yönetici girişini işler.
  void markSignedIn(String uid) {
    state = state.copyWith(status: AuthStatus.signedIn, uid: uid);
  }

  /// Çıkışı işler.
  void markSignedOut() {
    state = state.copyWith(status: AuthStatus.signedOut, clearUid: true);
  }
}
