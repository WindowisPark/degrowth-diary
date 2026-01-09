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

  const UnlockCondition({
    required this.categoryKey,
    required this.count,
  });

  @override
  List<Object?> get props => [categoryKey, count];
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
