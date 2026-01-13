import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user_monster.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/repositories/i_user_monster_repository.dart';
import '../models/user_monster_model.dart';

/// Firebase User Monster Repository 구현체
class FirebaseUserMonsterRepository implements IUserMonsterRepository {
  final FirebaseFirestore _firestore;
  final IAuthRepository _authRepository;

  FirebaseUserMonsterRepository(this._firestore, this._authRepository);

  CollectionReference<Map<String, dynamic>> get _collection {
    final userId = _authRepository.currentUserId;
    if (userId == null) throw const AuthFailure('로그인이 필요합니다');
    return _firestore.collection('users').doc(userId).collection('userMonsters');
  }

  @override
  Future<List<UserMonster>> getMyMonsters() async {
    try {
      final snapshot = await _collection
          .orderBy('unlockedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => UserMonsterModel.fromJson(doc.data(), doc.id).toEntity())
          .toList();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<UserMonster?> getById(String monsterId) async {
    try {
      final doc = await _collection.doc(monsterId).get();
      if (!doc.exists || doc.data() == null) return null;
      return UserMonsterModel.fromJson(doc.data()!, doc.id).toEntity();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> unlock(String monsterId) async {
    try {
      final model = UserMonsterModel.newUnlock(monsterId);
      await _collection.doc(monsterId).set(model.toJson());
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> addExp(String monsterId, int exp) async {
    try {
      // 현재 몬스터 정보 가져오기
      final doc = await _collection.doc(monsterId).get();
      if (!doc.exists) return;

      final currentMonster = UserMonsterModel.fromJson(doc.data()!, doc.id).toEntity();
      final newExp = currentMonster.exp + exp;

      // 레벨업 계산
      int newLevel = currentMonster.level;
      int remainingExp = newExp;

      while (remainingExp >= (newLevel * 100)) {
        remainingExp -= (newLevel * 100);
        newLevel++;
      }

      // 업데이트
      await _collection.doc(monsterId).update({
        'exp': remainingExp,
        'level': newLevel,
      });
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> incrementSummonCount(String monsterId) async {
    try {
      await _collection.doc(monsterId).update({
        'summonCount': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Stream<List<UserMonster>> watchMyMonsters() {
    return _collection
        .orderBy('unlockedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserMonsterModel.fromJson(doc.data(), doc.id).toEntity())
            .toList());
  }
}
