import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/sample_monsters.dart';
import '../domain/entities/monster.dart';
import 'user_monster_provider.dart';

/// 오늘의 특별 몬스터 (시간대/요일 조건 맞는 희귀 몬스터)
final todaySpecialMonsterProvider = Provider<Monster?>((ref) {
  final now = DateTime.now();
  final myMonsters = ref.watch(myMonstersStreamProvider).valueOrNull ?? [];
  final myMonsterIds = myMonsters.map((m) => m.monsterId).toSet();

  // 모든 몬스터 중 특수 조건이 있고 아직 안 가진 것들
  final allMonsters = SampleMonsters.all;
  final specialMonsters = allMonsters.where((monster) {
    // 이미 보유한 몬스터는 제외
    if (myMonsterIds.contains(monster.id)) return false;

    // 기본(common) 몬스터는 제외
    if (monster.rarity == 'common') return false;

    final condition = monster.unlockCondition;

    // 시간대 또는 요일 조건이 있는 몬스터만
    final hasSpecialCondition =
        condition.hourStart != null || condition.dayOfWeek != null;
    if (!hasSpecialCondition) return false;

    // 현재 시간이 조건에 맞는지 확인
    return condition.isSpecialConditionMet(now);
  }).toList();

  if (specialMonsters.isEmpty) return null;

  // 희귀도 우선순위로 정렬 (legendary > epic > rare)
  specialMonsters.sort((a, b) {
    final rarityOrder = {'legendary': 0, 'epic': 1, 'rare': 2, 'common': 3};
    return (rarityOrder[a.rarity] ?? 3).compareTo(rarityOrder[b.rarity] ?? 3);
  });

  return specialMonsters.first;
});

/// 특별 몬스터가 해금 가능한 상태인지 (조건 수 충족)
final isSpecialMonsterUnlockableProvider = FutureProvider<bool>((ref) async {
  final specialMonster = ref.watch(todaySpecialMonsterProvider);
  if (specialMonster == null) return false;

  // 기록 수 체크는 실제 구현 시 recordRepository 사용
  // MVP에서는 단순히 특별 몬스터가 있으면 true
  return true;
});
