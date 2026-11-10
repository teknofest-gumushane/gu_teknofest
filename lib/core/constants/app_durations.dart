/// İş süreleri (arayüz hareket süreleri `TfMotion`'dadır).
abstract final class AppDurations {
  /// Sahte veri okumalarına eklenen gecikme: "yükleniyor" durumunu görünür
  /// kılar.
  static const Duration mockLatency = Duration(milliseconds: 350);
}
