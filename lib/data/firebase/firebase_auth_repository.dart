import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';

/// Firebase Auth Repository 구현체
class FirebaseAuthRepository implements IAuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository(
    this._firebaseAuth,
    this._firestore, {
    GoogleSignIn? googleSignIn,
  }) : _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return _mapFirebaseUser(firebaseUser);
  }

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return _mapFirebaseUser(firebaseUser);
    });
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      print('[Auth] Starting Google Sign In...');
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('[Auth] Google Sign In cancelled');
        throw const AuthFailure('Google 로그인이 취소되었습니다');
      }
      print('[Auth] Google User: ${googleUser.email}');

      final googleAuth = await googleUser.authentication;
      print('[Auth] Got googleAuth - accessToken: ${googleAuth.accessToken != null}, idToken: ${googleAuth.idToken != null}');

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('[Auth] Created Firebase credential');

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      print('[Auth] Firebase signInWithCredential completed');

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        print('[Auth] Firebase user is null');
        throw const AuthFailure('로그인에 실패했습니다');
      }
      print('[Auth] Firebase User: ${firebaseUser.uid}');

      return _mapFirebaseUser(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('[Auth] FirebaseAuthException: ${e.code} - ${e.message}');
      throw AuthFailure(e.message ?? '인증에 실패했습니다');
    } on SocketException {
      print('[Auth] SocketException');
      throw const NetworkFailure();
    } catch (e) {
      print('[Auth] Unknown error: $e');
      rethrow;
    }
  }

  @override
  Future<User> signInWithApple() async {
    try {
      final appleProvider = firebase_auth.AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');

      final userCredential = await _firebaseAuth.signInWithProvider(appleProvider);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const AuthFailure('로그인에 실패했습니다');
      }

      return _mapFirebaseUser(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? '인증에 실패했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? '로그아웃에 실패했습니다');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthFailure('로그인이 필요합니다');
      }

      // 1. Firestore 데이터 삭제
      await _deleteUserData(user.uid);

      // 2. Firebase Auth 계정 삭제
      await user.delete();
      await _googleSignIn.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? '회원탈퇴에 실패했습니다');
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '데이터 삭제 중 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  /// Firestore 유저 데이터 삭제
  Future<void> _deleteUserData(String userId) async {
    final batch = _firestore.batch();

    // records 서브컬렉션 삭제
    final records = await _firestore
        .collection('users')
        .doc(userId)
        .collection('records')
        .get();
    for (var doc in records.docs) {
      batch.delete(doc.reference);
    }

    // userMonsters 서브컬렉션 삭제
    final userMonsters = await _firestore
        .collection('users')
        .doc(userId)
        .collection('userMonsters')
        .get();
    for (var doc in userMonsters.docs) {
      batch.delete(doc.reference);
    }

    // achievements 서브컬렉션 삭제
    final achievements = await _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .get();
    for (var doc in achievements.docs) {
      batch.delete(doc.reference);
    }

    // users 문서 삭제
    batch.delete(_firestore.collection('users').doc(userId));

    // 일괄 실행
    await batch.commit();
  }

  /// Firebase User를 도메인 User로 변환
  User _mapFirebaseUser(firebase_auth.User firebaseUser) {
    final now = DateTime.now();
    return User(
      id: firebaseUser.uid,
      nickname: firebaseUser.displayName ?? '익명',
      createdAt: firebaseUser.metadata.creationTime ?? now,
      updatedAt: now,
      timezone: 'Asia/Seoul',
      streakCount: 0,
      lastRecordDate: null,
      lastRecordAt: null,
      settings: const UserSettings.defaults(),
    );
  }
}
