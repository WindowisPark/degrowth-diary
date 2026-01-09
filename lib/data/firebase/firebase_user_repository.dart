import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../models/user_model.dart';

/// Firebase User Repository 구현체
class FirebaseUserRepository implements IUserRepository {
  final FirebaseFirestore _firestore;

  FirebaseUserRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users');

  @override
  Future<User?> getUser(String userId) async {
    try {
      final doc = await _collection.doc(userId).get();
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromJson(doc.data()!, doc.id).toEntity();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> createUser(User user) async {
    try {
      final model = UserModel.fromEntity(user);
      await _collection.doc(user.id).set(model.toJson());
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updateSettings(UserSettings settings) async {
    // Note: 이 메서드는 userId가 필요함 - Provider에서 처리
    throw UnimplementedError('Use updateSettingsForUser instead');
  }

  /// userId를 받아서 설정 업데이트
  Future<void> updateSettingsForUser(String userId, UserSettings settings) async {
    try {
      final model = UserSettingsModel.fromEntity(settings);
      await _collection.doc(userId).update({
        'settings': model.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updateNickname(String nickname) async {
    throw UnimplementedError('Use updateNicknameForUser instead');
  }

  /// userId를 받아서 닉네임 업데이트
  Future<void> updateNicknameForUser(String userId, String nickname) async {
    try {
      await _collection.doc(userId).update({
        'nickname': nickname,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Stream<User?> watchUser(String userId) {
    return _collection.doc(userId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromJson(doc.data()!, doc.id).toEntity();
    });
  }
}
