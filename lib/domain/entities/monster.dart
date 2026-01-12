import 'package:equatable/equatable.dart';

/// 몬스터 엔티티 (글로벌 도감)
class Monster extends Equatable {
  final String id;
  final String name;
  final String attribute;
  final String rarity;
  final String description;
  final String imageUrl;
  final UnlockCondition unlockCondition;
  final String? evolutionTo;
  final int stage;

  const Monster({
    required this.id,
    required this.name,
    required this.attribute,
    required this.rarity,
    required this.description,
    required this.imageUrl,
    required this.unlockCondition,
    this.evolutionTo,
    required this.stage,
  });

  Monster copyWith({
    String? id,
    String? name,
    String? attribute,
    String? rarity,
    String? description,
    String? imageUrl,
    UnlockCondition? unlockCondition,
    String? evolutionTo,
    int? stage,
  }) {
    return Monster(
      id: id ?? this.id,
      name: name ?? this.name,
      attribute: attribute ?? this.attribute,
      rarity: rarity ?? this.rarity,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      unlockCondition: unlockCondition ?? this.unlockCondition,
      evolutionTo: evolutionTo ?? this.evolutionTo,
      stage: stage ?? this.stage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        attribute,
        rarity,
        description,
        imageUrl,
        unlockCondition,
        evolutionTo,
        stage,
      ];
}

/// 해금 조건
class UnlockCondition extends Equatable {
  final String categoryKey;
  final int count;

  // 특수 조건 (옵션)
  final int? hourStart;      // 시간대 조건 시작 (0-23)
  final int? hourEnd;        // 시간대 조건 종료 (0-23)
  final int? dayOfWeek;      // 요일 조건 (1=월, 7=일)
  final String? subCategoryKey;  // 특정 소분류만
  final double bonusChance;  // 추가 획득 확률 (0.0-1.0)

  const UnlockCondition({
    required this.categoryKey,
    required this.count,
    this.hourStart,
    this.hourEnd,
    this.dayOfWeek,
    this.subCategoryKey,
    this.bonusChance = 0.0,
  });

  /// 시간대 조건 충족 여부
  bool isTimeConditionMet(DateTime time) {
    if (hourStart == null || hourEnd == null) return true;

    final hour = time.hour;
    if (hourStart! <= hourEnd!) {
      // 같은 날 (예: 9시-18시)
      return hour >= hourStart! && hour <= hourEnd!;
    } else {
      // 자정 넘김 (예: 23시-2시)
      return hour >= hourStart! || hour <= hourEnd!;
    }
  }

  /// 요일 조건 충족 여부
  bool isDayConditionMet(DateTime time) {
    if (dayOfWeek == null) return true;
    return time.weekday == dayOfWeek;
  }

  /// 모든 특수 조건 충족 여부
  bool isSpecialConditionMet(DateTime time) {
    return isTimeConditionMet(time) && isDayConditionMet(time);
  }

  @override
  List<Object?> get props => [
        categoryKey,
        count,
        hourStart,
        hourEnd,
        dayOfWeek,
        subCategoryKey,
        bonusChance,
      ];
}

/// 몬스터 희귀도
enum MonsterRarity {
  common('common'),
  rare('rare'),
  epic('epic'),
  legendary('legendary');

  const MonsterRarity(this.value);
  final String value;

  static MonsterRarity fromString(String value) {
    return MonsterRarity.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MonsterRarity.common,
    );
  }
}
