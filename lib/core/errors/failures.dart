/// 에러 타입 정의
sealed class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// 네트워크 연결 오류
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = '네트워크 연결을 확인해주세요']);
}

/// 인증 오류
class AuthFailure extends Failure {
  const AuthFailure([super.message = '인증에 실패했습니다']);
}

/// 서버 오류
class ServerFailure extends Failure {
  const ServerFailure([super.message = '서버 오류가 발생했습니다']);
}

/// 로컬 캐시 오류
class CacheFailure extends Failure {
  const CacheFailure([super.message = '로컬 데이터를 불러올 수 없습니다']);
}

/// 유효성 검증 오류
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = '입력값이 올바르지 않습니다']);
}

/// 권한 오류
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = '권한이 없습니다']);
}

/// 데이터를 찾을 수 없음
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = '데이터를 찾을 수 없습니다']);
}
