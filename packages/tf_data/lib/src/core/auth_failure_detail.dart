// Kaynak: gu_kulupler/packages/gu_data (MIT, aynı yazar). Yorumlardaki D-xx / CD-xx / T-xx / PLAN
// ve ekran kimlikleri (AUT-01, DLG-02 …) o projeye aittir; bu projenin kararları docs/decisions.md içindedir.
import 'package:equatable/equatable.dart';

/// `AuthError.lockedOut` / `AuthError.resendCooldown` ile dönen
/// başarısızlığın ek bilgisi (PLAN §10.1 "+ `retryAfter`").
///
/// `FirebaseFailure.detail` alanında taşınır. ViewModel geri sayımı **hedef
/// an** olarak saklar ([retryAfter]); [remaining] aynı bilginin başarısızlık
/// anındaki süre karşılığıdır (TST-X3 `{seconds}`, DLG-02).
final class AuthFailureDetail extends Equatable {
  /// [retryAfter] anına kadar beklenmesi gereken başarısızlık bilgisi.
  const AuthFailureDetail({required this.retryAfter, required this.remaining});

  /// İşlemin yeniden denenebileceği an (UTC).
  final DateTime retryAfter;

  /// Başarısızlık anında [retryAfter]'a kalan süre (her zaman pozitif).
  final Duration remaining;

  @override
  List<Object?> get props => [retryAfter, remaining];

  @override
  bool? get stringify => true;
}
