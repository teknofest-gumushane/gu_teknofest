import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/core/session/session_state.dart';
import 'package:gu_teknofest/core/session/session_view_model.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('başlangıçta ziyaretçidir', () {
    final state = container.read(sessionViewModelProvider);

    expect(state, const SessionState());
    expect(state.isSignedIn, isFalse);
    expect(state.uid, isNull);
  });

  test('giriş ve çıkış durumu günceller', () {
    final notifier = container.read(sessionViewModelProvider.notifier)
      ..markSignedIn('yonetici-1');

    expect(
      container.read(sessionViewModelProvider),
      const SessionState(status: AuthStatus.signedIn, uid: 'yonetici-1'),
    );

    notifier.markSignedOut();

    expect(container.read(sessionViewModelProvider), const SessionState());
  });

  test('SessionState.copyWith clearUid kimliği kaldırır', () {
    const state = SessionState(status: AuthStatus.signedIn, uid: 'a');

    expect(state.copyWith(clearUid: true).uid, isNull);
    expect(state.copyWith(status: AuthStatus.signedOut).uid, 'a');
  });
}
