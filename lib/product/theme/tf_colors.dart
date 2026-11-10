import 'package:flutter/material.dart';

/// Renk token'ları (`docs/token-map.md`). Ekran kodu `context.tf.colors.*` ile
/// erişir; renk değeri yalnızca bu dosyada yazılır.
@immutable
final class TfColors extends ThemeExtension<TfColors> {
  /// Renk kümesi oluşturur.
  const TfColors({
    required this.brandPurple,
    required this.primary,
    required this.deep,
    required this.accent,
    required this.surface,
    required this.card,
    required this.text,
    required this.textMuted,
    required this.textSubtle,
    required this.onBrand,
    required this.onBrandMuted,
    required this.headerBackground,
    required this.border,
    required this.divider,
    required this.glass,
    required this.glassBorder,
    required this.scrim,
    required this.shadow,
    required this.danger,
    required this.success,
  });

  /// Açık tema renkleri (şimdilik tek tema).
  static const TfColors light = TfColors(
    brandPurple: Color(0xFF682D8B),
    primary: Color(0xFF2F97C1),
    deep: Color(0xFF1B3C73),
    accent: Color(0xFFF47A1F),
    surface: Color(0xFFF8F9FA),
    card: Color(0xFFFFFFFF),
    text: Color(0xFF0F172A),
    textMuted: Color(0xB31B3C73),
    textSubtle: Color(0x991B3C73),
    onBrand: Color(0xFFFFFFFF),
    onBrandMuted: Color(0xCCFFFFFF),
    headerBackground: Color(0xF2682D8B),
    border: Color(0x332F97C1),
    divider: Color(0xFFE2E8F0),
    glass: Color(0x1AFFFFFF),
    glassBorder: Color(0x4DFFFFFF),
    scrim: Color(0xCC0F172A),
    shadow: Color(0x592B4F87),
    danger: Color(0xFFDC2626),
    success: Color(0xFF16A34A),
  );

  /// Üst bar, alt bilgi, gradyan başlangıcı.
  final Color brandPurple;

  /// Butonlar, linkler, etiketler, odak çerçevesi.
  final Color primary;

  /// Başlıklar, koyu metin, gradyan bitişi.
  final Color deep;

  /// Bölüm üst etiketleri, üzerine gelme, rozetler.
  final Color accent;

  /// Sayfa arka planı.
  final Color surface;

  /// Kartlar, pencereler, çekmece.
  final Color card;

  /// Gövde metni.
  final Color text;

  /// İkincil metin (`deep` %70).
  final Color textMuted;

  /// Açıklama, ipucu (`deep` %60).
  final Color textSubtle;

  /// Mor / gradyan üstündeki metin.
  final Color onBrand;

  /// Mor üstünde ikincil metin, menü linkleri (%80).
  final Color onBrandMuted;

  /// Yapışkan üst bar (`brandPurple` %95).
  final Color headerBackground;

  /// Kart ve alan kenarlıkları (`primary` %20).
  final Color border;

  /// Ayırıcı çizgiler.
  final Color divider;

  /// Mor üstündeki yarı saydam yüzeyler (%10).
  final Color glass;

  /// Bunların kenarlığı (%30).
  final Color glassBorder;

  /// Pencere ve çekmece arkası karartma (%80).
  final Color scrim;

  /// Yumuşak gölge rengi (%35).
  final Color shadow;

  /// Hata durumu.
  final Color danger;

  /// Başarı durumu.
  final Color success;

  @override
  TfColors copyWith({
    Color? brandPurple,
    Color? primary,
    Color? deep,
    Color? accent,
    Color? surface,
    Color? card,
    Color? text,
    Color? textMuted,
    Color? textSubtle,
    Color? onBrand,
    Color? onBrandMuted,
    Color? headerBackground,
    Color? border,
    Color? divider,
    Color? glass,
    Color? glassBorder,
    Color? scrim,
    Color? shadow,
    Color? danger,
    Color? success,
  }) => TfColors(
    brandPurple: brandPurple ?? this.brandPurple,
    primary: primary ?? this.primary,
    deep: deep ?? this.deep,
    accent: accent ?? this.accent,
    surface: surface ?? this.surface,
    card: card ?? this.card,
    text: text ?? this.text,
    textMuted: textMuted ?? this.textMuted,
    textSubtle: textSubtle ?? this.textSubtle,
    onBrand: onBrand ?? this.onBrand,
    onBrandMuted: onBrandMuted ?? this.onBrandMuted,
    headerBackground: headerBackground ?? this.headerBackground,
    border: border ?? this.border,
    divider: divider ?? this.divider,
    glass: glass ?? this.glass,
    glassBorder: glassBorder ?? this.glassBorder,
    scrim: scrim ?? this.scrim,
    shadow: shadow ?? this.shadow,
    danger: danger ?? this.danger,
    success: success ?? this.success,
  );

  @override
  TfColors lerp(TfColors? other, double t) {
    if (other == null) return this;
    return TfColors(
      brandPurple: Color.lerp(brandPurple, other.brandPurple, t) ?? brandPurple,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      deep: Color.lerp(deep, other.deep, t) ?? deep,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      card: Color.lerp(card, other.card, t) ?? card,
      text: Color.lerp(text, other.text, t) ?? text,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t) ?? textSubtle,
      onBrand: Color.lerp(onBrand, other.onBrand, t) ?? onBrand,
      onBrandMuted:
          Color.lerp(onBrandMuted, other.onBrandMuted, t) ?? onBrandMuted,
      headerBackground:
          Color.lerp(headerBackground, other.headerBackground, t) ??
          headerBackground,
      border: Color.lerp(border, other.border, t) ?? border,
      divider: Color.lerp(divider, other.divider, t) ?? divider,
      glass: Color.lerp(glass, other.glass, t) ?? glass,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t) ?? glassBorder,
      scrim: Color.lerp(scrim, other.scrim, t) ?? scrim,
      shadow: Color.lerp(shadow, other.shadow, t) ?? shadow,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      success: Color.lerp(success, other.success, t) ?? success,
    );
  }
}
