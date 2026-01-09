import '../entities/user_monster.dart';

/// 유저 몬스터 Repository 인터페이스
abstract class IUserMonsterRepository {
  /// 유저가 보유한 몬스터 조회
  Future<List<UserMonster>> getMyMonsters();

  /// 특정 몬스터 보유 여부
  Future<UserMonster?> getById(String monsterId);

  /// 몬스터 해금
  Future<void> unlock(String monsterId);

  /// 경험치 추가
  Future<void> addExp(String monsterId, int exp);

  /// 소환 횟수 증가
  Future<void> incrementSummonCount(String monsterId);

  /// 실시간 스트림
  Stream<List<UserMonster>> watchMyMonsters();
}
