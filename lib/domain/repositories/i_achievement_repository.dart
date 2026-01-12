import '../entities/achievement.dart';

/// 업적 Repository 인터페이스
abstract class IAchievementRepository {
  /// 유저 업적 목록 실시간 감시
  Stream<List<UserAchievement>> watchUserAchievements(String userId);

  /// 특정 유저 업적 조회
  Future<UserAchievement?> getUserAchievement(String userId, String achievementId);

  /// 업적 해금
  Future<void> unlockAchievement(String userId, String achievementId);
}
