import '../entities/record.dart';

/// 기록 Repository 인터페이스
abstract class IRecordRepository {
  /// 오늘 기록 조회
  Future<List<Record>> getTodayRecords();

  /// 기간별 기록 조회
  Future<List<Record>> getRecordsByDateRange(
    DateTime start,
    DateTime end,
  );

  /// 특정 날짜 기록 조회
  Future<List<Record>> getRecordsByDate(String recordDate);

  /// 기록 생성
  Future<String> createRecord(Record record);

  /// 기록 수정
  Future<void> updateRecord(String id, Map<String, dynamic> data);

  /// 기록 삭제
  Future<void> deleteRecord(String id);

  /// 오늘 기록 수 조회
  Future<int> getTodayRecordCount();

  /// 카테고리별 기록 수 조회
  Future<int> getCategoryCount(String categoryKey);

  /// 실시간 오늘 기록 스트림
  Stream<List<Record>> watchTodayRecords();
}
