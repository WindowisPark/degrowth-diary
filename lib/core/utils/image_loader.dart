import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// 몬스터 이미지 로더 유틸리티
///
/// 로컬 에셋(assets/)과 원격 이미지(http/https) 모두 지원
/// imageUrl이 'assets/'로 시작하면 Image.asset, 아니면 Image.network 사용
class ImageLoader {
  ImageLoader._();

  /// Monster ID를 기반으로 이미지 경로 자동 생성
  ///
  /// 파일명 규칙: {category}_{id}_{expression}.png
  /// 예시: food_001 -> assets/images/monsters/food/food_001_idle.png
  static String getMonsterImagePath(
    String monsterId, {
    MonsterExpression expression = MonsterExpression.idle,
  }) {
    // monsterId가 비어있으면 빈 문자열 반환
    if (monsterId.isEmpty) return '';

    // monsterId 파싱 (예: 'food_001' -> category='food', id='001')
    final parts = monsterId.split('_');
    if (parts.length < 2) return '';

    final category = parts[0]; // food, sleep, exercise, money, productivity
    final suffix = switch (expression) {
      MonsterExpression.idle => 'idle',
      MonsterExpression.happy => 'happy',
      MonsterExpression.sleep => 'sleep',
    };

    return 'assets/images/monsters/$category/${monsterId}_$suffix.png';
  }

  /// 몬스터 이미지 로드 (Monster ID로 자동 경로 생성)
  ///
  /// [monsterId]: 몬스터 ID (예: 'food_001')
  /// [expression]: 표정 (기본: idle)
  /// [imageUrl]: 명시적 이미지 URL (옵션, 없으면 monsterId로 자동 생성)
  static Widget loadMonsterImageById(
    String monsterId, {
    String? imageUrl,
    MonsterExpression expression = MonsterExpression.idle,
    double width = 50,
    double height = 50,
    BoxFit fit = BoxFit.contain,
    Widget? fallback,
    Color? fallbackColor,
  }) {
    // imageUrl이 명시되어 있고 비어있지 않으면 그것 사용
    String finalUrl = imageUrl ?? '';

    // imageUrl이 없으면 monsterId로 자동 생성
    if (finalUrl.isEmpty) {
      finalUrl = getMonsterImagePath(monsterId, expression: expression);
    }

    return loadMonsterImage(
      finalUrl,
      width: width,
      height: height,
      fit: fit,
      fallback: fallback,
      fallbackColor: fallbackColor,
    );
  }

  /// 몬스터 이미지 로드
  ///
  /// [imageUrl]: 이미지 경로 (assets/... 또는 https://...)
  /// [width]: 이미지 너비
  /// [height]: 이미지 높이
  /// [fit]: 이미지 fit 방식
  /// [fallback]: 로딩 실패 시 표시할 위젯 (기본: 기본 아이콘)
  static Widget loadMonsterImage(
    String imageUrl, {
    double width = 50,
    double height = 50,
    BoxFit fit = BoxFit.contain,
    Widget? fallback,
    Color? fallbackColor,
  }) {
    // imageUrl이 비어있으면 fallback 표시
    if (imageUrl.isEmpty) {
      return fallback ?? _buildDefaultIcon(width, height, fallbackColor);
    }

    // assets로 시작하면 로컬 에셋
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Failed to load asset image: $imageUrl');
          debugPrint('Error: $error');
          return fallback ?? _buildDefaultIcon(width, height, fallbackColor);
        },
      );
    }

    // http/https로 시작하면 원격 이미지
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingPlaceholder(width, height);
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Failed to load network image: $imageUrl');
          debugPrint('Error: $error');
          return fallback ?? _buildDefaultIcon(width, height, fallbackColor);
        },
      );
    }

    // 알 수 없는 형식이면 fallback
    debugPrint('Unknown image URL format: $imageUrl');
    return fallback ?? _buildDefaultIcon(width, height, fallbackColor);
  }

  /// 로딩 중 플레이스홀더
  static Widget _buildLoadingPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.textHint),
          ),
        ),
      ),
    );
  }

  /// 기본 아이콘 (이미지 로드 실패 시)
  static Widget _buildDefaultIcon(
    double width,
    double height,
    Color? color,
  ) {
    final iconColor = color ?? AppColors.textHint;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.pest_control,
        color: iconColor,
        size: width * 0.5,
      ),
    );
  }

  /// 몬스터 표정별 이미지 로드 (향후 확장용)
  ///
  /// 현재는 idle만 지원, 추가 표정(happy/sleep)은 Monster entity 확장 후 사용
  static Widget loadMonsterImageWithExpression(
    String baseUrl, {
    MonsterExpression expression = MonsterExpression.idle,
    double width = 50,
    double height = 50,
    BoxFit fit = BoxFit.contain,
    Widget? fallback,
    Color? fallbackColor,
  }) {
    // baseUrl에서 _idle.png 제거하고 표정에 맞는 suffix 추가
    String imageUrl = baseUrl;
    if (baseUrl.contains('_idle.png')) {
      final suffix = switch (expression) {
        MonsterExpression.idle => '_idle.png',
        MonsterExpression.happy => '_happy.png',
        MonsterExpression.sleep => '_sleep.png',
      };
      imageUrl = baseUrl.replaceAll('_idle.png', suffix);
    }

    return loadMonsterImage(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      fallback: fallback,
      fallbackColor: fallbackColor,
    );
  }
}

/// 몬스터 표정 (향후 확장용)
enum MonsterExpression {
  idle,  // 기본
  happy, // 기쁨
  sleep, // 졸림
}
