import 'package:flutter/material.dart';

/// 소분류 데이터
class SubCategoryData {
  final String key;
  final String label;
  final String? emoji;

  const SubCategoryData({
    required this.key,
    required this.label,
    this.emoji,
  });
}

/// 카테고리 데이터
class CategoryData {
  final String key;
  final String label;
  final IconData icon;
  final Color color;
  final List<SubCategoryData> subCategories;

  const CategoryData({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
    this.subCategories = const [],
  });
}

/// 카테고리 목록
abstract class Categories {
  static const List<CategoryData> all = [
    CategoryData(
      key: 'food',
      label: '식습관',
      icon: Icons.restaurant,
      color: Color(0xFFFF6B6B),
      subCategories: [
        SubCategoryData(key: 'late_night', label: '야식', emoji: '🍜'),
        SubCategoryData(key: 'overeating', label: '과식', emoji: '🍔'),
        SubCategoryData(key: 'junk_food', label: '정크푸드', emoji: '🍟'),
        SubCategoryData(key: 'skipped_meal', label: '끼니 거름', emoji: '🚫'),
        SubCategoryData(key: 'sweet', label: '단 음식', emoji: '🍰'),
        SubCategoryData(key: 'alcohol', label: '음주', emoji: '🍺'),
        SubCategoryData(key: 'food_etc', label: '기타', emoji: '🍽️'),
      ],
    ),
    CategoryData(
      key: 'sleep',
      label: '수면',
      icon: Icons.bedtime,
      color: Color(0xFF9B59B6),
      subCategories: [
        SubCategoryData(key: 'late_sleep', label: '늦잠', emoji: '😴'),
        SubCategoryData(key: 'insomnia', label: '불면', emoji: '🌙'),
        SubCategoryData(key: 'oversleep', label: '과다수면', emoji: '💤'),
        SubCategoryData(key: 'irregular', label: '불규칙 수면', emoji: '⏰'),
        SubCategoryData(key: 'nap', label: '낮잠', emoji: '🛋️'),
        SubCategoryData(key: 'sleep_etc', label: '기타', emoji: '🌜'),
      ],
    ),
    CategoryData(
      key: 'exercise',
      label: '운동',
      icon: Icons.fitness_center,
      color: Color(0xFF3498DB),
      subCategories: [
        SubCategoryData(key: 'no_exercise', label: '운동 안 함', emoji: '🛋️'),
        SubCategoryData(key: 'lazy', label: '게으름', emoji: '🦥'),
        SubCategoryData(key: 'skip_plan', label: '계획 미이행', emoji: '📋'),
        SubCategoryData(key: 'sedentary', label: '오래 앉아있음', emoji: '🪑'),
        SubCategoryData(key: 'exercise_etc', label: '기타', emoji: '🏃'),
      ],
    ),
    CategoryData(
      key: 'money',
      label: '소비',
      icon: Icons.attach_money,
      color: Color(0xFF2ECC71),
      subCategories: [
        SubCategoryData(key: 'impulse', label: '충동구매', emoji: '🛒'),
        SubCategoryData(key: 'waste', label: '낭비', emoji: '💸'),
        SubCategoryData(key: 'delivery', label: '배달음식', emoji: '🛵'),
        SubCategoryData(key: 'subscription', label: '구독서비스', emoji: '📺'),
        SubCategoryData(key: 'game', label: '게임과금', emoji: '🎮'),
        SubCategoryData(key: 'money_etc', label: '기타', emoji: '💰'),
      ],
    ),
    CategoryData(
      key: 'productivity',
      label: '생산성',
      icon: Icons.phone_android,
      color: Color(0xFFF39C12),
      subCategories: [
        SubCategoryData(key: 'phone', label: '스마트폰', emoji: '📱'),
        SubCategoryData(key: 'sns', label: 'SNS', emoji: '📲'),
        SubCategoryData(key: 'youtube', label: '유튜브', emoji: '▶️'),
        SubCategoryData(key: 'game_time', label: '게임', emoji: '🎮'),
        SubCategoryData(key: 'procrastinate', label: '미루기', emoji: '⏳'),
        SubCategoryData(key: 'distracted', label: '집중력 저하', emoji: '🤯'),
        SubCategoryData(key: 'productivity_etc', label: '기타', emoji: '💻'),
      ],
    ),
    CategoryData(
      key: 'etc',
      label: '기타',
      icon: Icons.more_horiz,
      color: Color(0xFF95A5A6),
      subCategories: [
        SubCategoryData(key: 'bad_habit', label: '나쁜 습관', emoji: '😈'),
        SubCategoryData(key: 'stress', label: '스트레스', emoji: '😤'),
        SubCategoryData(key: 'anger', label: '화냄', emoji: '😡'),
        SubCategoryData(key: 'negative', label: '부정적 생각', emoji: '😔'),
        SubCategoryData(key: 'etc_etc', label: '기타', emoji: '❓'),
      ],
    ),
  ];

  /// 키로 카테고리 데이터 찾기
  static CategoryData? getByKey(String key) {
    try {
      return all.firstWhere((c) => c.key == key);
    } catch (_) {
      return null;
    }
  }

  /// 키로 소분류 찾기
  static SubCategoryData? getSubByKey(String categoryKey, String subKey) {
    final category = getByKey(categoryKey);
    if (category == null) return null;
    try {
      return category.subCategories.firstWhere((s) => s.key == subKey);
    } catch (_) {
      return null;
    }
  }

  /// 소분류 키로 라벨 가져오기 (카테고리 키 없이)
  static String getSubLabel(String subKey) {
    for (final category in all) {
      for (final sub in category.subCategories) {
        if (sub.key == subKey) return sub.label;
      }
    }
    return subKey;
  }

  /// 키로 아이콘 가져오기
  static IconData getIcon(String key) {
    return getByKey(key)?.icon ?? Icons.help_outline;
  }

  /// 키로 라벨 가져오기
  static String getLabel(String key) {
    return getByKey(key)?.label ?? key;
  }

  /// 키로 색상 가져오기
  static Color getColor(String key) {
    return getByKey(key)?.color ?? const Color(0xFF95A5A6);
  }
}
