import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/monster.dart';
import '../../domain/repositories/i_monster_catalog_repository.dart';
import '../models/monster_model.dart';

/// Firebase Monster Catalog Repository 구현체
class FirebaseMonsterCatalogRepository implements IMonsterCatalogRepository {
  final FirebaseFirestore _firestore;

  FirebaseMonsterCatalogRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('monsters');

  @override
  Future<List<Monster>> getAll() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => MonsterModel.fromJson(doc.data(), doc.id).toEntity())
          .toList();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<Monster?> getById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return MonsterModel.fromJson(doc.data()!, doc.id).toEntity();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<Monster>> getByCategory(String categoryKey) async {
    try {
      final snapshot = await _collection
          .where('unlockCondition.categoryKey', isEqualTo: categoryKey)
          .get();
      return snapshot.docs
          .map((doc) => MonsterModel.fromJson(doc.data(), doc.id).toEntity())
          .toList();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<Monster>> getByRarity(String rarity) async {
    try {
      final snapshot = await _collection
          .where('rarity', isEqualTo: rarity)
          .get();
      return snapshot.docs
          .map((doc) => MonsterModel.fromJson(doc.data(), doc.id).toEntity())
          .toList();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<Monster?> checkUnlockCondition({
    required String categoryKey,
    required int count,
  }) async {
    try {
      // 해당 카테고리에서 count와 정확히 일치하는 해금 조건을 가진 몬스터 찾기
      final snapshot = await _collection
          .where('unlockCondition.categoryKey', isEqualTo: categoryKey)
          .where('unlockCondition.count', isEqualTo: count)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return MonsterModel.fromJson(doc.data(), doc.id).toEntity();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }
}
