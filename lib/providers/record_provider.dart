import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/date_utils.dart';
import '../domain/entities/monster.dart';
import '../domain/entities/record.dart';
import 'achievement_provider.dart';
import 'monster_unlock_provider.dart';
import 'repository_providers.dart';
import 'user_provider.dart';

/// 오늘 기록 스트림
final todayRecordsStreamProvider = StreamProvider<List<Record>>((ref) {
  final recordRepo = ref.watch(recordRepositoryProvider);
  return recordRepo.watchTodayRecords();
});

/// 오늘 기록 (Future)
final todayRecordsProvider = FutureProvider<List<Record>>((ref) async {
  final recordRepo = ref.watch(recordRepositoryProvider);
  return recordRepo.getTodayRecords();
});

/// 오늘 기록 수
final todayRecordCountProvider = FutureProvider<int>((ref) async {
  final recordRepo = ref.watch(recordRepositoryProvider);
  return recordRepo.getTodayRecordCount();
});

/// 특정 날짜 기록
final recordsByDateProvider = FutureProvider.family<List<Record>, String>((ref, date) async {
  final recordRepo = ref.watch(recordRepositoryProvider);
  return recordRepo.getRecordsByDate(date);
});

/// 최근 자주 사용한 소분류 (카테고리키, 소분류키) 쌍
final recentSubCategoriesProvider = Provider<List<({String categoryKey, String subCategoryKey})>>((ref) {
  final todayRecords = ref.watch(todayRecordsStreamProvider).valueOrNull ?? [];

  // 오늘 기록에서 소분류 추출 (중복 제거, 최신순)
  final seen = <String>{};
  final result = <({String categoryKey, String subCategoryKey})>[];

  for (final record in todayRecords) {
    final key = '${record.categoryKey}:${record.subCategoryKey}';
    if (!seen.contains(key)) {
      seen.add(key);
      result.add((categoryKey: record.categoryKey, subCategoryKey: record.subCategoryKey));
    }
    if (result.length >= 5) break; // 최대 5개
  }

  return result;
});

/// Record Notifier
final recordNotifierProvider = NotifierProvider<RecordNotifier, AsyncValue<void>>(
  RecordNotifier.new,
);

/// 기록 생성 결과 (기록 ID + 새로 획득한 몬스터)
class RecordResult {
  final String recordId;
  final Monster? unlockedMonster;

  RecordResult({required this.recordId, this.unlockedMonster});
}

class RecordNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  /// 기록 생성 + 몬스터 획득 체크
  Future<RecordResult?> createRecord({
    required String categoryKey,
    required String subCategoryKey,
    required int severity,
    String? memo,
  }) async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      final recordRepo = ref.read(recordRepositoryProvider);
      final unlockService = ref.read(monsterUnlockProvider);

      final record = Record(
        id: '', // Firestore에서 자동 생성
        categoryKey: categoryKey,
        subCategoryKey: subCategoryKey,
        severity: severity,
        memo: memo,
        recordDate: AppDateUtils.todayRecordDate,
        createdAt: DateTime.now(),
        hasMonster: false,
        monsterId: null,
      );

      // 1. 스트릭 업데이트
      try {
        await ref.read(userNotifierProvider.notifier).updateStreakOnRecord(
              AppDateUtils.todayRecordDate,
            );
      } catch (e) {
        print('[Record] Failed to update streak: $e');
        // 스트릭 업데이트 실패해도 기록은 계속
      }

      // 2. 기록 생성
      final recordId = await recordRepo.createRecord(record);

      // 3. 몬스터 획득 체크 (subCategoryKey도 전달)
      final unlockedMonster = await unlockService.checkAndUnlock(
        categoryKey,
        subCategoryKey: subCategoryKey,
      );

      // 4. 업적 체크 (기록 관련)
      try {
        await ref.read(achievementNotifierProvider.notifier).checkRecordAchievements();
      } catch (e) {
        // 업적 체크 실패해도 기록은 성공
      }

      // 5. 기존 몬스터에 경험치 추가
      await unlockService.addExpToActiveMonster(categoryKey, severity);

      // 6. 획득한 몬스터가 있으면 기록에 연결
      if (unlockedMonster != null) {
        await recordRepo.updateRecord(recordId, {
          'hasMonster': true,
          'monsterId': unlockedMonster.id,
        });
      }

      return RecordResult(recordId: recordId, unlockedMonster: unlockedMonster);
    });

    state = result.hasError
        ? AsyncValue.error(result.error!, result.stackTrace!)
        : const AsyncValue.data(null);

    return result.valueOrNull;
  }

  /// 기록에 몬스터 연결
  Future<void> linkMonster(String recordId, String monsterId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final recordRepo = ref.read(recordRepositoryProvider);
      await recordRepo.updateRecord(recordId, {
        'hasMonster': true,
        'monsterId': monsterId,
      });
    });
  }

  /// 기록 삭제
  Future<void> deleteRecord(String recordId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final recordRepo = ref.read(recordRepositoryProvider);
      await recordRepo.deleteRecord(recordId);
    });
  }
}
