import 'package:flutter/material.dart';

/// 앱 컬러 상수 - 다크 네온 테마
abstract class AppColors {
  // Primary - 네온 시안
  static const primary = Color(0xFF00F5D4);
  static const primaryLight = Color(0xFF72EFDD);
  static const primaryDark = Color(0xFF00B4A0);

  // Secondary - 네온 마젠타
  static const secondary = Color(0xFFFF006E);
  static const secondaryLight = Color(0xFFFF5C9E);
  static const secondaryDark = Color(0xFFCC0058);

  // Accent - 네온 퍼플
  static const accent = Color(0xFFBB86FC);
  static const accentLight = Color(0xFFE2B6FF);
  static const accentDark = Color(0xFF8858C8);

  // Background - 딥 다크
  static const background = Color(0xFF0D0D1A);
  static const backgroundLight = Color(0xFF1A1A2E);
  static const surface = Color(0xFF16162A);
  static const surfaceLight = Color(0xFF252542);
  static const surfaceVariant = Color(0xFF2D2D4A);

  // 라이트 테마용 (필요시)
  static const backgroundLightTheme = Color(0xFFF0F0F8);
  static const surfaceLightTheme = Colors.white;

  // Text
  static const textPrimary = Color(0xFFF0F0F0);
  static const textSecondary = Color(0xFFA0A0B8);
  static const textHint = Color(0xFF6A6A80);
  static const textOnPrimary = Color(0xFF0D0D1A);

  // Severity levels - 네온 그라데이션
  static const severity1 = Color(0xFF00F5A0); // 가벼움 - 네온 그린
  static const severity2 = Color(0xFFB8FF00); // 라임
  static const severity3 = Color(0xFFFFE600); // 네온 옐로우
  static const severity4 = Color(0xFFFF9500); // 네온 오렌지
  static const severity5 = Color(0xFFFF0055); // 심각 - 네온 레드

  // Rarity - 몬스터 레어도
  static const rarityCommon = Color(0xFF8A8A9A);    // 커먼 - 회색
  static const rarityRare = Color(0xFF00D4FF);      // 레어 - 시안
  static const rarityEpic = Color(0xFFBB86FC);      // 에픽 - 퍼플
  static const rarityLegendary = Color(0xFFFFD700); // 레전드 - 골드

  // Status
  static const success = Color(0xFF00F5A0);
  static const warning = Color(0xFFFFE600);
  static const error = Color(0xFFFF0055);
  static const info = Color(0xFF00D4FF);

  // Border & Glow
  static const border = Color(0xFF3A3A5C);
  static const borderLight = Color(0xFF4A4A6A);
  static const glow = Color(0xFF00F5D4);
  static const glowSecondary = Color(0xFFFF006E);

  // Card gradient colors
  static const cardGradientStart = Color(0xFF1A1A2E);
  static const cardGradientEnd = Color(0xFF252542);

  // Monster colors
  static const monsterShadow = Color(0xFF000000);
  static const monsterGlow = Color(0xFF00F5D4);
}
