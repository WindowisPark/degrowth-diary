import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/monster.dart';
import 'repository_providers.dart';

/// 전체 몬스터 도감
final allMonstersProvider = FutureProvider<List<Monster>>((ref) async {
  final catalogRepo = ref.watch(monsterCatalogRepositoryProvider);
  return catalogRepo.getAll();
});

/// 특정 몬스터 조회
final monsterByIdProvider = FutureProvider.family<Monster?, String>((ref, id) async {
  final catalogRepo = ref.watch(monsterCatalogRepositoryProvider);
  return catalogRepo.getById(id);
});

/// 카테고리별 몬스터
final monstersByCategoryProvider = FutureProvider.family<List<Monster>, String>((ref, categoryKey) async {
  final catalogRepo = ref.watch(monsterCatalogRepositoryProvider);
  return catalogRepo.getByCategory(categoryKey);
});

/// 희귀도별 몬스터
final monstersByRarityProvider = FutureProvider.family<List<Monster>, String>((ref, rarity) async {
  final catalogRepo = ref.watch(monsterCatalogRepositoryProvider);
  return catalogRepo.getByRarity(rarity);
});

/// 해금 조건 체크
final unlockCheckProvider = FutureProvider.family<Monster?, ({String categoryKey, int count})>((ref, params) async {
  final catalogRepo = ref.watch(monsterCatalogRepositoryProvider);
  return catalogRepo.checkUnlockCondition(
    categoryKey: params.categoryKey,
    count: params.count,
  );
});
