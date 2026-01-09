import '../entities/monster.dart';

/// 몬스터 도감 Repository 인터페이스 (글로벌)
abstract class IMonsterCatalogRepository {
  /// 전체 몬스터 도감 조회
  Future<List<Monster>> getAll();

  /// 특정 몬스터 조회
  Future<Monster?> getById(String id);

  /// 카테고리별 몬스터 조회
  Future<List<Monster>> getByCategory(String categoryKey);

  /// 희귀도별 몬스터 조회
  Future<List<Monster>> getByRarity(String rarity);

  /// 해금 조건 체크
  /// 해당 카테고리의 count 횟수로 해금 가능한 몬스터 반환
  Future<Monster?> checkUnlockCondition({
    required String categoryKey,
    required int count,
  });
}
