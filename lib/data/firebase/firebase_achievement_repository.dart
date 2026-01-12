import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/repositories/i_achievement_repository.dart';
import '../models/achievement_model.dart';

/// Firebase Achievement Repository 구현체
class FirebaseAchievementRepository implements IAchievementRepository {
  final FirebaseFirestore _firestore;

  FirebaseAchievementRepository(this._firestore);

  /// 유저 업적 컬렉션 참조
  CollectionReference<Map<String, dynamic>> _userAchievementsRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('achievements');
  }

  @override
  Stream<List<UserAchievement>> watchUserAchievements(String userId) {
    return _userAchievementsRef(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserAchievementModel.fromJson(doc.data(), doc.id).toEntity();
      }).toList();
    });
  }

  @override
  Future<UserAchievement?> getUserAchievement(
    String userId,
    String achievementId,
  ) async {
    try {
      final doc = await _userAchievementsRef(userId).doc(achievementId).get();
      if (!doc.exists || doc.data() == null) return null;
      return UserAchievementModel.fromJson(doc.data()!, doc.id).toEntity();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> unlockAchievement(String userId, String achievementId) async {
    try {
      await _userAchievementsRef(userId).doc(achievementId).set({
        'unlockedAt': FieldValue.serverTimestamp(),
        'progress': null,
      });
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }
}
