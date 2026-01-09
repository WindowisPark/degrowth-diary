import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/date_utils.dart';
import '../domain/entities/record.dart';
import 'repository_providers.dart';

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

/// Record Notifier
final recordNotifierProvider = NotifierProvider<RecordNotifier, AsyncValue<void>>(
  RecordNotifier.new,
);

class RecordNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  /// 기록 생성
  Future<String?> createRecord({
    required String categoryKey,
    required String subCategoryKey,
    required int severity,
    String? memo,
  }) async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      final recordRepo = ref.read(recordRepositoryProvider);

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

      return await recordRepo.createRecord(record);
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
