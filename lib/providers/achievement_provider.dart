import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/achievement_definitions.dart';
import '../domain/entities/achievement.dart';
import 'auth_provider.dart';
import 'repository_providers.dart';
import 'user_monster_provider.dart';
import 'user_provider.dart';

/// 유저 업적 목록 스트림
final userAchievementsStreamProvider = StreamProvider<List<UserAchievement>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return Stream.value([]);

  final achievementRepo = ref.watch(achievementRepositoryProvider);
  return achievementRepo.watchUserAchievements(currentUser.id);
});

/// Achievement Notifier (업적 해금 로직)
class AchievementNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  /// 기록 관련 업적 체크 (기록 생성 후 호출)
  Future<List<Achievement>> checkRecordAchievements() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return [];

    final achievementRepo = ref.read(achievementRepositoryProvider);
    final userProfile = ref.read(userProfileStreamProvider).valueOrNull;
    if (userProfile == null) return [];

    final unlockedAchievements = <Achievement>[];

    try {
      // TODO: getTotalRecordCount() 메서드 추가 필요
      // MVP에서는 간단하게 처리
      // final totalRecords = await recordRepo.getTotalRecordCount();

      // 1. 첫 기록 체크 (임시로 주석 처리)
      // if (totalRecords == 1) {
      //   final existing = await achievementRepo.getUserAchievement(
      //     currentUser.id,
      //     AchievementDefinitions.firstRecord.id,
      //   );
      //   if (existing == null) {
      //     await achievementRepo.unlockAchievement(
      //       currentUser.id,
      //       AchievementDefinitions.firstRecord.id,
      //     );
      //     unlockedAchievements.add(AchievementDefinitions.firstRecord);
      //   }
      // }

      // 2. N개 기록 체크 (임시로 주석 처리)
      // if (totalRecords == 10) {
      //   final existing = await achievementRepo.getUserAchievement(
      //     currentUser.id,
      //     AchievementDefinitions.record10.id,
      //   );
      //   if (existing == null) {
      //     await achievementRepo.unlockAchievement(
      //       currentUser.id,
      //       AchievementDefinitions.record10.id,
      //     );
      //     unlockedAchievements.add(AchievementDefinitions.record10);
      //   }
      // }

      // 3. 연속 기록 체크
      final streak = userProfile.streakCount;

      if (streak == 3) {
        final existing = await achievementRepo.getUserAchievement(
          currentUser.id,
          AchievementDefinitions.streak3.id,
        );
        if (existing == null || !existing.isUnlocked) {
          await achievementRepo.unlockAchievement(
            currentUser.id,
            AchievementDefinitions.streak3.id,
          );
          unlockedAchievements.add(AchievementDefinitions.streak3);
        }
      } else if (streak == 7) {
        final existing = await achievementRepo.getUserAchievement(
          currentUser.id,
          AchievementDefinitions.streak7.id,
        );
        if (existing == null || !existing.isUnlocked) {
          await achievementRepo.unlockAchievement(
            currentUser.id,
            AchievementDefinitions.streak7.id,
          );
          unlockedAchievements.add(AchievementDefinitions.streak7);
        }
      } else if (streak == 30) {
        final existing = await achievementRepo.getUserAchievement(
          currentUser.id,
          AchievementDefinitions.streak30.id,
        );
        if (existing == null || !existing.isUnlocked) {
          await achievementRepo.unlockAchievement(
            currentUser.id,
            AchievementDefinitions.streak30.id,
          );
          unlockedAchievements.add(AchievementDefinitions.streak30);
        }
      }

      return unlockedAchievements;
    } catch (e) {
      // 에러 발생 시 빈 리스트 반환 (업적 체크 실패해도 기록은 성공)
      return [];
    }
  }

  /// 몬스터 수집 업적 체크 (몬스터 획득 후 호출)
  Future<List<Achievement>> checkCollectionAchievements() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return [];

    final achievementRepo = ref.read(achievementRepositoryProvider);
    final myMonsterCount = ref.read(myMonsterCountProvider);

    final unlockedAchievements = <Achievement>[];

    try {
      if (myMonsterCount == 5) {
        final existing = await achievementRepo.getUserAchievement(
          currentUser.id,
          AchievementDefinitions.collect5.id,
        );
        if (existing == null || !existing.isUnlocked) {
          await achievementRepo.unlockAchievement(
            currentUser.id,
            AchievementDefinitions.collect5.id,
          );
          unlockedAchievements.add(AchievementDefinitions.collect5);
        }
      } else if (myMonsterCount == 10) {
        final existing = await achievementRepo.getUserAchievement(
          currentUser.id,
          AchievementDefinitions.collect10.id,
        );
        if (existing == null || !existing.isUnlocked) {
          await achievementRepo.unlockAchievement(
            currentUser.id,
            AchievementDefinitions.collect10.id,
          );
          unlockedAchievements.add(AchievementDefinitions.collect10);
        }
      } else if (myMonsterCount == 20) {
        final existing = await achievementRepo.getUserAchievement(
          currentUser.id,
          AchievementDefinitions.collect20.id,
        );
        if (existing == null || !existing.isUnlocked) {
          await achievementRepo.unlockAchievement(
            currentUser.id,
            AchievementDefinitions.collect20.id,
          );
          unlockedAchievements.add(AchievementDefinitions.collect20);
        }
      }

      return unlockedAchievements;
    } catch (e) {
      // 에러 발생 시 빈 리스트 반환
      return [];
    }
  }
}

final achievementNotifierProvider = NotifierProvider<AchievementNotifier, AsyncValue<void>>(
  AchievementNotifier.new,
);
