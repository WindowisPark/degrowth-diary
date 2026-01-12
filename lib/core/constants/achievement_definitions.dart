import '../../domain/entities/achievement.dart';

/// 업적 정의 (MVP)
abstract class AchievementDefinitions {
  // ============================================================
  // 기록 관련 업적
  // ============================================================

  /// 첫 기록
  static const firstRecord = Achievement(
    id: 'first_record',
    title: '첫 퇴보',
    description: '첫 번째 기록을 완료했습니다',
    type: AchievementType.record,
    iconEmoji: '🎉',
    rewardExp: 10,
  );

  /// 10번 기록
  static const record10 = Achievement(
    id: 'record_10',
    title: '퇴보 전문가',
    description: '총 10번의 기록을 완료했습니다',
    type: AchievementType.record,
    targetValue: 10,
    iconEmoji: '📝',
    rewardExp: 50,
  );

  // ============================================================
  // 연속 기록 업적
  // ============================================================

  /// 3일 연속
  static const streak3 = Achievement(
    id: 'streak_3',
    title: '3일 연속 퇴보',
    description: '3일 연속으로 기록했습니다',
    type: AchievementType.streak,
    targetValue: 3,
    iconEmoji: '🔥',
    rewardExp: 30,
  );

  /// 7일 연속
  static const streak7 = Achievement(
    id: 'streak_7',
    title: '일주일 퇴화',
    description: '7일 연속으로 기록했습니다',
    type: AchievementType.streak,
    targetValue: 7,
    iconEmoji: '💪',
    rewardExp: 100,
  );

  /// 30일 연속
  static const streak30 = Achievement(
    id: 'streak_30',
    title: '한 달 퇴화왕',
    description: '30일 연속으로 기록했습니다',
    type: AchievementType.streak,
    targetValue: 30,
    iconEmoji: '👑',
    rewardExp: 500,
  );

  // ============================================================
  // 몬스터 수집 업적
  // ============================================================

  /// 5마리 수집
  static const collect5 = Achievement(
    id: 'collect_5',
    title: '초보 수집가',
    description: '5마리의 몬스터를 획득했습니다',
    type: AchievementType.collection,
    targetValue: 5,
    iconEmoji: '🎒',
    rewardExp: 100,
  );

  /// 10마리 수집
  static const collect10 = Achievement(
    id: 'collect_10',
    title: '중급 수집가',
    description: '10마리의 몬스터를 획득했습니다',
    type: AchievementType.collection,
    targetValue: 10,
    iconEmoji: '📚',
    rewardExp: 300,
  );

  /// 20마리 수집
  static const collect20 = Achievement(
    id: 'collect_20',
    title: '마스터 수집가',
    description: '20마리의 몬스터를 획득했습니다',
    type: AchievementType.collection,
    targetValue: 20,
    iconEmoji: '🏆',
    rewardExp: 1000,
  );

  // ============================================================
  // 전체 업적 목록
  // ============================================================

  static const all = [
    firstRecord,
    record10,
    streak3,
    streak7,
    streak30,
    collect5,
    collect10,
    collect20,
  ];

  /// ID로 업적 조회
  static Achievement? getById(String id) {
    try {
      return all.firstWhere((achievement) => achievement.id == id);
    } catch (e) {
      return null;
    }
  }
}
