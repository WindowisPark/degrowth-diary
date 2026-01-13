import '../../core/constants/sample_monsters.dart';
import '../../domain/entities/monster.dart';
import '../../domain/repositories/i_monster_catalog_repository.dart';

/// Local Monster Catalog Repository (SampleMonsters 사용)
class LocalMonsterCatalogRepository implements IMonsterCatalogRepository {
  @override
  Future<List<Monster>> getAll() async {
    return SampleMonsters.all;
  }

  @override
  Future<Monster?> getById(String id) async {
    try {
      return SampleMonsters.all.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Monster>> getByCategory(String categoryKey) async {
    return SampleMonsters.getByAttribute(categoryKey);
  }

  @override
  Future<List<Monster>> getByRarity(String rarity) async {
    return SampleMonsters.all.where((m) => m.rarity == rarity).toList();
  }

  @override
  Future<Monster?> checkUnlockCondition({
    required String categoryKey,
    required int count,
  }) async {
    try {
      return SampleMonsters.all.firstWhere(
        (m) =>
            m.unlockCondition.categoryKey == categoryKey &&
            m.unlockCondition.count == count,
      );
    } catch (_) {
      return null;
    }
  }
}
