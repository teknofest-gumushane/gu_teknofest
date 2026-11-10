/// Çalışma ortamı. `--dart-define=ENV=<değer>` ile seçilir
/// (`bash tool/dev.sh --env …`).
enum AppEnv {
  /// Sahte veri (`assets/mock`); Firebase yok.
  mock('mock'),

  /// Yerel Firebase emülatörü (backend fazı).
  emulator('emulator'),

  /// Gerçek Firebase projesi (backend fazı).
  production('prod');

  const AppEnv(this.define);

  /// `ENV` tanımındaki karşılığı.
  final String define;
}

/// Ortam seçimi.
abstract final class AppEnvironment {
  /// Derleme sırasında verilen ham `ENV` değeri.
  static const String rawEnv = String.fromEnvironment('ENV');

  /// Geçerli ortam.
  static AppEnv get current => parse(rawEnv);

  /// [raw] değerinin ortamı. Boş değer [AppEnv.mock]'tur: arayüz fazında
  /// varsayılan sahte veridir. Bilinmeyen değer [ArgumentError] fırlatır.
  static AppEnv parse(String raw) => switch (raw) {
    '' => AppEnv.mock,
    _ => AppEnv.values.firstWhere(
      (candidate) => candidate.define == raw,
      orElse: () => throw ArgumentError.value(
        raw,
        'ENV',
        'mock, emulator ya da prod olmalı',
      ),
    ),
  };

  /// [env] için gerçek veri kaynağı bağlı mı. Backend fazına kadar yalnızca
  /// sahte veri vardır; diğer ortamlar da sahte veriyle açılır (D-26).
  static bool hasBackend(AppEnv env) => false;
}
