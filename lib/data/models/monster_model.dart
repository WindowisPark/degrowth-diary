import '../../domain/entities/monster.dart';

/// Monster DTO (Firebase 변환용)
class MonsterModel {
  final String id;
  final String name;
  final String attribute;
  final String rarity;
  final String description;
  final String imageUrl;
  final UnlockConditionModel unlockCondition;
  final String? evolutionTo;
  final int stage;

  const MonsterModel({
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

  /// Firestore → Model
  factory MonsterModel.fromJson(Map<String, dynamic> json, String id) {
    return MonsterModel(
      id: id,
      name: json['name'] as String,
      attribute: json['attribute'] as String,
      rarity: json['rarity'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      unlockCondition: UnlockConditionModel.fromJson(
        json['unlockCondition'] as Map<String, dynamic>,
      ),
      evolutionTo: json['evolutionTo'] as String?,
      stage: json['stage'] as int,
    );
  }

  /// Model → Entity
  Monster toEntity() {
    return Monster(
      id: id,
      name: name,
      attribute: attribute,
      rarity: rarity,
      description: description,
      imageUrl: imageUrl,
      unlockCondition: unlockCondition.toEntity(),
      evolutionTo: evolutionTo,
      stage: stage,
    );
  }

  /// Model → Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'attribute': attribute,
      'rarity': rarity,
      'description': description,
      'imageUrl': imageUrl,
      'unlockCondition': unlockCondition.toJson(),
      'evolutionTo': evolutionTo,
      'stage': stage,
    };
  }
}

/// UnlockCondition DTO
class UnlockConditionModel {
  final String categoryKey;
  final int count;

  const UnlockConditionModel({
    required this.categoryKey,
    required this.count,
  });

  factory UnlockConditionModel.fromJson(Map<String, dynamic> json) {
    return UnlockConditionModel(
      categoryKey: json['categoryKey'] as String,
      count: json['count'] as int,
    );
  }

  UnlockCondition toEntity() {
    return UnlockCondition(
      categoryKey: categoryKey,
      count: count,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryKey': categoryKey,
      'count': count,
    };
  }
}
