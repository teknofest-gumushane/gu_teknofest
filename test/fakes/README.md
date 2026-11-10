# Fake'ler

Testlerde mock kütüphanesi kullanılmaz (`CLAUDE.md` §3); bağımlılıklar el yazımı fake'lerle değiştirilir.

- Repository'ler için çoğu zaman fake yazmaya gerek yoktur: `tf_data`'daki `Mock*Repository` sınıfları
  bellekte çalışır ve `MockDataSource` ile istenen veriyi verir (`test/helpers/pump_app.dart` →
  `setUpTestDependencies`).
- Hata ya da gecikme durumunu denemek gerekiyorsa buraya `fake_<alan>_repository.dart` ekle; arayüzü
  uygula, döndüreceği sonucu kurucudan al.
