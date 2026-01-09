import '../entities/user.dart';

/// 인증 Repository 인터페이스
abstract class IAuthRepository {
  /// 현재 유저
  User? get currentUser;

  /// 현재 유저 ID
  String? get currentUserId;

  /// 인증 상태 스트림
  Stream<User?> get authStateChanges;

  /// Google 로그인
  Future<User> signInWithGoogle();

  /// Apple 로그인
  Future<User> signInWithApple();

  /// 로그아웃
  Future<void> signOut();

  /// 회원탈퇴
  Future<void> deleteAccount();
}
