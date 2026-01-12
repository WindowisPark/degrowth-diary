import 'package:equatable/equatable.dart';

/// 업적 엔티티 (글로벌 정의)
class Achievement extends Equatable {
  final String id;              // "first_record"
  final String title;           // "첫 퇴보"
  final String description;     // "첫 번째 기록을 완료했습니다"
  final AchievementType type;   // record / streak / collection
  final int? targetValue;       // 수치형 목표 (null이면 단일 달성)
  final String iconEmoji;       // "🎉"
  final int rewardExp;          // 보상 경험치 (향후 확장)

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.targetValue,
    required this.iconEmoji,
    required this.rewardExp,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        targetValue,
        iconEmoji,
        rewardExp,
      ];
}

/// 업적 타입
enum AchievementType {
  record,      // 기록 관련
  streak,      // 연속 기록
  collection,  // 몬스터 수집
}

/// 유저 업적 진행 상황
class UserAchievement extends Equatable {
  final String achievementId;
  final DateTime? unlockedAt;   // null이면 미획득
  final int? progress;          // 현재 진행도 (MVP에서 미사용, 향후 확장)

  const UserAchievement({
    required this.achievementId,
    this.unlockedAt,
    this.progress,
  });

  /// 획득 여부
  bool get isUnlocked => unlockedAt != null;

  UserAchievement copyWith({
    String? achievementId,
    DateTime? unlockedAt,
    int? progress,
  }) {
    return UserAchievement(
      achievementId: achievementId ?? this.achievementId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [achievementId, unlockedAt, progress];
}
