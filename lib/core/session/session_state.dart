import 'package:equatable/equatable.dart';

/// Oturum durumu.
enum AuthStatus {
  /// Giriş yapılmamış (ziyaretçi).
  signedOut,

  /// Yönetici girişi yapılmış.
  signedIn,
}

/// Uygulama genelindeki oturum bilgisi. Yönlendirme korumaları ve admin
/// ekranları bunu izler.
final class SessionState extends Equatable {
  /// Oturum durumu oluşturur.
  const SessionState({this.status = AuthStatus.signedOut, this.uid});

  /// Giriş durumu.
  final AuthStatus status;

  /// Giriş yapan yöneticinin kimliği; giriş yoksa `null`.
  final String? uid;

  /// Yönetici girişi var mı.
  bool get isSignedIn => status == AuthStatus.signedIn;

  /// Verilen alanları değişmiş kopya; [clearUid] kimliği kaldırır.
  SessionState copyWith({
    AuthStatus? status,
    String? uid,
    bool clearUid = false,
  }) => SessionState(
    status: status ?? this.status,
    uid: clearUid ? null : (uid ?? this.uid),
  );

  @override
  List<Object?> get props => [status, uid];
}
