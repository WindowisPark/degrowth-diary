import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/user_monster.dart';
import 'repository_providers.dart';

/// 유저 몬스터 스트림
final myMonstersStreamProvider = StreamProvider<List<UserMonster>>((ref) {
  final userMonsterRepo = ref.watch(userMonsterRepositoryProvider);
  return userMonsterRepo.watchMyMonsters();
});

/// 유저 몬스터 (Future)
final myMonstersProvider = FutureProvider<List<UserMonster>>((ref) async {
  final userMonsterRepo = ref.watch(userMonsterRepositoryProvider);
  return userMonsterRepo.getMyMonsters();
});

/// 특정 유저 몬스터 보유 여부
final userMonsterByIdProvider = FutureProvider.family<UserMonster?, String>((ref, monsterId) async {
  final userMonsterRepo = ref.watch(userMonsterRepositoryProvider);
  return userMonsterRepo.getById(monsterId);
});

/// 보유 몬스터 수
final myMonsterCountProvider = Provider<int>((ref) {
  final monsters = ref.watch(myMonstersStreamProvider).valueOrNull;
  return monsters?.length ?? 0;
});

/// User Monster Notifier
final userMonsterNotifierProvider = NotifierProvider<UserMonsterNotifier, AsyncValue<void>>(
  UserMonsterNotifier.new,
);

class UserMonsterNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  /// 몬스터 해금
  Future<void> unlock(String monsterId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userMonsterRepo = ref.read(userMonsterRepositoryProvider);
      await userMonsterRepo.unlock(monsterId);
    });
  }

  /// 경험치 추가
  Future<void> addExp(String monsterId, int exp) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userMonsterRepo = ref.read(userMonsterRepositoryProvider);
      await userMonsterRepo.addExp(monsterId, exp);
    });
  }

  /// 소환 횟수 증가
  Future<void> incrementSummonCount(String monsterId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userMonsterRepo = ref.read(userMonsterRepositoryProvider);
      await userMonsterRepo.incrementSummonCount(monsterId);
    });
  }
}
