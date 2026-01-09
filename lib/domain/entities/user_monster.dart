import 'package:equatable/equatable.dart';

/// 유저 소유 몬스터 엔티티
class UserMonster extends Equatable {
  final String monsterId;
  final int level;
  final int exp;
  final int summonCount;
  final DateTime unlockedAt;

  const UserMonster({
    required this.monsterId,
    required this.level,
    required this.exp,
    required this.summonCount,
    required this.unlockedAt,
  });

  UserMonster copyWith({
    String? monsterId,
    int? level,
    int? exp,
    int? summonCount,
    DateTime? unlockedAt,
  }) {
    return UserMonster(
      monsterId: monsterId ?? this.monsterId,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      summonCount: summonCount ?? this.summonCount,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  /// 다음 레벨까지 필요한 경험치
  int get expToNextLevel => level * 100;

  /// 현재 레벨 진행률 (0.0 ~ 1.0)
  double get levelProgress => exp / expToNextLevel;

  /// 레벨업 가능 여부
  bool get canLevelUp => exp >= expToNextLevel;

  @override
  List<Object?> get props => [
        monsterId,
        level,
        exp,
        summonCount,
        unlockedAt,
      ];
}
