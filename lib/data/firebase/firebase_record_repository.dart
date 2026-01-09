import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/record.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/repositories/i_record_repository.dart';
import '../models/record_model.dart';

/// Firebase Record Repository 구현체
class FirebaseRecordRepository implements IRecordRepository {
  final FirebaseFirestore _firestore;
  final IAuthRepository _authRepository;

  FirebaseRecordRepository(this._firestore, this._authRepository);

  /// 현재 유저의 records 컬렉션 참조
  CollectionReference<Map<String, dynamic>> get _collection {
    final userId = _authRepository.currentUserId;
    if (userId == null) throw const AuthFailure('로그인이 필요합니다');
    return _firestore.collection('users').doc(userId).collection('records');
  }

  @override
  Future<List<Record>> getTodayRecords() async {
    try {
      final today = AppDateUtils.todayRecordDate;
      final snapshot = await _collection
          .where('recordDate', isEqualTo: today)
          .get();

      final records = snapshot.docs
          .map((doc) => RecordModel.fromJson(doc.data(), doc.id).toEntity())
          .toList();
      // 클라이언트 정렬 (최신순)
      records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return records;
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<Record>> getRecordsByDateRange(DateTime start, DateTime end) async {
    try {
      final startDate = AppDateUtils.toRecordDate(start);
      final endDate = AppDateUtils.toRecordDate(end);

      final snapshot = await _collection
          .where('recordDate', isGreaterThanOrEqualTo: startDate)
          .where('recordDate', isLessThanOrEqualTo: endDate)
          .get();

      final records = snapshot.docs
          .map((doc) => RecordModel.fromJson(doc.data(), doc.id).toEntity())
          .toList();
      // 클라이언트 정렬 (날짜 내림차순 → 시간 내림차순)
      records.sort((a, b) {
        final dateCompare = b.recordDate.compareTo(a.recordDate);
        if (dateCompare != 0) return dateCompare;
        return b.createdAt.compareTo(a.createdAt);
      });
      return records;
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<Record>> getRecordsByDate(String recordDate) async {
    try {
      final snapshot = await _collection
          .where('recordDate', isEqualTo: recordDate)
          .get();

      final records = snapshot.docs
          .map((doc) => RecordModel.fromJson(doc.data(), doc.id).toEntity())
          .toList();
      // 클라이언트 정렬 (최신순)
      records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return records;
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<String> createRecord(Record record) async {
    try {
      final model = RecordModel.fromEntity(record);
      final docRef = await _collection.add(model.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updateRecord(String id, Map<String, dynamic> data) async {
    try {
      await _collection.doc(id).update(data);
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> deleteRecord(String id) async {
    try {
      await _collection.doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<int> getTodayRecordCount() async {
    try {
      final today = AppDateUtils.todayRecordDate;
      final snapshot = await _collection
          .where('recordDate', isEqualTo: today)
          .count()
          .get();
      return snapshot.count ?? 0;
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Future<int> getCategoryCount(String categoryKey) async {
    try {
      final snapshot = await _collection
          .where('categoryKey', isEqualTo: categoryKey)
          .count()
          .get();
      return snapshot.count ?? 0;
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류가 발생했습니다');
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  @override
  Stream<List<Record>> watchTodayRecords() {
    final today = AppDateUtils.todayRecordDate;
    return _collection
        .where('recordDate', isEqualTo: today)
        .snapshots()
        .map((snapshot) {
          final records = snapshot.docs
              .map((doc) => RecordModel.fromJson(doc.data(), doc.id).toEntity())
              .toList();
          // 클라이언트 정렬 (최신순)
          records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return records;
        });
  }
}
