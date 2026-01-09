/// 유효성 검증 유틸리티
abstract class Validators {
  /// severity 범위 검증 (1~5)
  static bool isValidSeverity(int severity) {
    return severity >= 1 && severity <= 5;
  }

  /// 닉네임 유효성 검증
  static bool isValidNickname(String nickname) {
    if (nickname.isEmpty) return false;
    if (nickname.length > 20) return false;
    // 특수문자 제한 (한글, 영문, 숫자, _, - 만 허용)
    final regex = RegExp(r'^[가-힣a-zA-Z0-9_-]+$');
    return regex.hasMatch(nickname);
  }

  /// 메모 길이 검증
  static bool isValidMemo(String? memo) {
    if (memo == null) return true;
    return memo.length <= 500;
  }

  /// 푸시 시간 포맷 검증 ("HH:mm")
  static bool isValidPushTime(String time) {
    final regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    return regex.hasMatch(time);
  }

  /// categoryKey 유효성 검증
  static bool isValidCategoryKey(String key) {
    const validKeys = [
      'food',
      'sleep',
      'exercise',
      'money',
      'productivity',
      'relationship',
      'habit',
      'other',
    ];
    return validKeys.contains(key);
  }
}
