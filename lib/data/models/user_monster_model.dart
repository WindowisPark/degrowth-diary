import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_monster.dart';

/// UserMonster DTO (Firebase 변환용)
class UserMonsterModel {
  final String monsterId;
  final int level;
  final int exp;
  final int summonCount;
  final DateTime unlockedAt;

  const UserMonsterModel({
    required this.monsterId,
    required this.level,
    required this.exp,
    required this.summonCount,
    required this.unlockedAt,
  });

  /// Entity → Model
  factory UserMonsterModel.fromEntity(UserMonster userMonster) {
    return UserMonsterModel(
      monsterId: userMonster.monsterId,
      level: userMonster.level,
      exp: userMonster.exp,
      summonCount: userMonster.summonCount,
      unlockedAt: userMonster.unlockedAt,
    );
  }

  /// Firestore → Model
  factory UserMonsterModel.fromJson(Map<String, dynamic> json, String id) {
    return UserMonsterModel(
      monsterId: id,
      level: json['level'] as int? ?? 1,
      exp: json['exp'] as int? ?? 0,
      summonCount: json['summonCount'] as int? ?? 1,
      unlockedAt: (json['unlockedAt'] as Timestamp).toDate(),
    );
  }

  /// Model → Entity
  UserMonster toEntity() {
    return UserMonster(
      monsterId: monsterId,
      level: level,
      exp: exp,
      summonCount: summonCount,
      unlockedAt: unlockedAt,
    );
  }

  /// Model → Firestore (생성용)
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'exp': exp,
      'summonCount': summonCount,
      'unlockedAt': FieldValue.serverTimestamp(),
    };
  }

  /// 신규 해금 시 기본값
  factory UserMonsterModel.newUnlock(String monsterId) {
    return UserMonsterModel(
      monsterId: monsterId,
      level: 1,
      exp: 0,
      summonCount: 1,
      unlockedAt: DateTime.now(),
    );
  }
}
