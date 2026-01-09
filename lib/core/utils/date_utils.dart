import 'package:intl/intl.dart';

/// 날짜 관련 유틸리티
abstract class AppDateUtils {
  /// recordDate 형식으로 변환 ("2026-01-09")
  static String toRecordDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// recordDate 문자열을 DateTime으로 변환
  static DateTime fromRecordDate(String recordDate) {
    return DateFormat('yyyy-MM-dd').parse(recordDate);
  }

  /// 오늘 날짜의 recordDate
  static String get todayRecordDate => toRecordDate(DateTime.now());

  /// 오늘의 시작 시간 (00:00:00)
  static DateTime get todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 오늘의 끝 시간 (23:59:59)
  static DateTime get todayEnd {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  /// 두 날짜가 같은 날인지 확인
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// 어제 날짜
  static DateTime get yesterday {
    return DateTime.now().subtract(const Duration(days: 1));
  }

  /// 연속 기록 확인을 위한 날짜 차이 계산
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inDays;
  }

  /// 표시용 날짜 포맷 ("1월 9일")
  static String toDisplayDate(DateTime date) {
    return DateFormat('M월 d일').format(date);
  }

  /// 표시용 시간 포맷 ("오후 3:30")
  static String toDisplayTime(DateTime date) {
    return DateFormat('a h:mm', 'ko_KR').format(date);
  }

  /// 표시용 날짜+시간 포맷 ("1월 9일 오후 3:30")
  static String toDisplayDateTime(DateTime date) {
    return '${toDisplayDate(date)} ${toDisplayTime(date)}';
  }
}
