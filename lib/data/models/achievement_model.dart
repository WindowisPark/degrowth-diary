import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/achievement.dart';

/// User Achievement Model (DTO)
class UserAchievementModel {
  final String achievementId;
  final DateTime? unlockedAt;
  final int? progress;

  const UserAchievementModel({
    required this.achievementId,
    this.unlockedAt,
    this.progress,
  });

  /// Firestore JSON으로부터 생성
  factory UserAchievementModel.fromJson(Map<String, dynamic> json, String id) {
    return UserAchievementModel(
      achievementId: id,
      unlockedAt: json['unlockedAt'] != null
          ? (json['unlockedAt'] as Timestamp).toDate()
          : null,
      progress: json['progress'] as int?,
    );
  }

  /// Firestore JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      if (unlockedAt != null) 'unlockedAt': Timestamp.fromDate(unlockedAt!),
      'progress': progress,
    };
  }

  /// Entity로 변환
  UserAchievement toEntity() {
    return UserAchievement(
      achievementId: achievementId,
      unlockedAt: unlockedAt,
      progress: progress,
    );
  }

  /// Entity로부터 생성
  factory UserAchievementModel.fromEntity(UserAchievement entity) {
    return UserAchievementModel(
      achievementId: entity.achievementId,
      unlockedAt: entity.unlockedAt,
      progress: entity.progress,
    );
  }
}
