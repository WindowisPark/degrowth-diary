import '../entities/user.dart';

/// 유저 Repository 인터페이스
abstract class IUserRepository {
  /// 유저 정보 조회
  Future<User?> getUser(String userId);

  /// 유저 생성
  Future<void> createUser(User user);

  /// 유저 설정 업데이트
  Future<void> updateSettings(UserSettings settings);

  /// 닉네임 업데이트
  Future<void> updateNickname(String nickname);

  /// 유저 정보 스트림
  Stream<User?> watchUser(String userId);
}
