import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/sample_monsters.dart';
import '../domain/entities/monster.dart';
import 'achievement_provider.dart';
import 'repository_providers.dart';

/// 몬스터 획득 체크 및 해금 처리
final monsterUnlockProvider = Provider((ref) => MonsterUnlockService(ref));

class MonsterUnlockService {
  final Ref _ref;

  MonsterUnlockService(this._ref);

  /// 기록 생성 후 호출 - 새로 획득한 몬스터 반환 (없으면 null)
  Future<Monster?> checkAndUnlock(String categoryKey, {String? subCategoryKey}) async {
    final recordRepo = _ref.read(recordRepositoryProvider);
    final userMonsterRepo = _ref.read(userMonsterRepositoryProvider);
    final now = DateTime.now();

    // 해당 카테고리 기록 수 조회
    final categoryCount = await recordRepo.getCategoryCount(categoryKey);

    // 해당 카테고리의 몬스터들 중 조건 충족 확인
    final categoryMonsters = SampleMonsters.getByAttribute(categoryKey);

    // 스테이지 순으로 정렬 (낮은 스테이지부터 획득)
    categoryMonsters.sort((a, b) => a.stage.compareTo(b.stage));

    for (final monster in categoryMonsters) {
      final condition = monster.unlockCondition;

      // 기본 조건 충족 확인
      if (condition.categoryKey != categoryKey ||
          categoryCount < condition.count) {
        continue;
      }

      // 소분류 조건 확인
      if (condition.subCategoryKey != null &&
          condition.subCategoryKey != subCategoryKey) {
        continue;
      }

      // 특수 조건 (시간대, 요일) 확인
      if (!condition.isSpecialConditionMet(now)) {
        continue;
      }

      // 이미 보유 중인지 확인
      final existing = await userMonsterRepo.getById(monster.id);
      if (existing == null) {
        // 희귀도에 따른 획득 확률
        final baseChance = _getBaseChance(monster.rarity);
        final totalChance = baseChance + condition.bonusChance;

        // 확률 체크
        final random = DateTime.now().microsecond / 1000000; // 0.0-1.0
        if (random > totalChance) {
          continue; // 획득 실패
        }

        // 새로 해금
        await userMonsterRepo.unlock(monster.id);

        // 업적 체크 (몬스터 수집)
        try {
          await _ref.read(achievementNotifierProvider.notifier).checkCollectionAchievements();
        } catch (e) {
          // 업적 체크 실패해도 몬스터 해금은 성공
        }

        return monster;
      }
    }

    return null; // 새로 획득한 몬스터 없음
  }

  /// 희귀도별 기본 획득 확률
  double _getBaseChance(String rarity) {
    switch (rarity) {
      case 'common':
        return 1.0; // 100%
      case 'rare':
        return 0.5; // 50%
      case 'epic':
        return 0.2; // 20%
      case 'legendary':
        return 0.05; // 5%
      default:
        return 1.0;
    }
  }

  /// 기존 보유 몬스터에 경험치 추가 (기록 시)
  Future<void> addExpToActiveMonster(String categoryKey, int severity) async {
    final userMonsterRepo = _ref.read(userMonsterRepositoryProvider);

    // 해당 카테고리의 몬스터 중 보유한 것 찾기
    final categoryMonsters = SampleMonsters.getByAttribute(categoryKey);
    final myMonsters = await userMonsterRepo.getMyMonsters();
    final myMonsterIds = myMonsters.map((m) => m.monsterId).toSet();

    // 가장 높은 스테이지의 보유 몬스터에 경험치 추가
    final ownedCategoryMonsters = categoryMonsters
        .where((m) => myMonsterIds.contains(m.id))
        .toList()
      ..sort((a, b) => b.stage.compareTo(a.stage));

    if (ownedCategoryMonsters.isNotEmpty) {
      final targetMonster = ownedCategoryMonsters.first;
      // severity에 비례한 경험치 (1~5 → 10~50)
      final exp = severity * 10;
      await userMonsterRepo.addExp(targetMonster.id, exp);
      await userMonsterRepo.incrementSummonCount(targetMonster.id);
    }
  }
}
