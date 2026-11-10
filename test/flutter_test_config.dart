import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/product/theme/tf_typography.dart';

/// Tüm testlerden önce çalışır: gömülü Inter yazı tipini yükler. Böylece metin
/// ölçüleri tarayıcıdakiyle aynıdır ve taşma testleri gerçeği yansıtır
/// (varsayılan test yazı tipinde her harf kare genişliğindedir).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final loader = FontLoader(TfTypography.fontFamily);
  for (final weight in const ['Regular', 'Medium', 'SemiBold']) {
    final bytes = await File('assets/fonts/Inter-$weight.ttf').readAsBytes();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
  await testMain();
}
