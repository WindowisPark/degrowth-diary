import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/record.dart';

/// Record DTO (Firebase 변환용)
class RecordModel {
  final String id;
  final String categoryKey;
  final String subCategoryKey;
  final int severity;
  final String? memo;
  final String recordDate;
  final DateTime createdAt;
  final bool hasMonster;
  final String? monsterId;

  const RecordModel({
    required this.id,
    required this.categoryKey,
    required this.subCategoryKey,
    required this.severity,
    this.memo,
    required this.recordDate,
    required this.createdAt,
    required this.hasMonster,
    this.monsterId,
  });

  /// Entity → Model
  factory RecordModel.fromEntity(Record record) {
    return RecordModel(
      id: record.id,
      categoryKey: record.categoryKey,
      subCategoryKey: record.subCategoryKey,
      severity: record.severity,
      memo: record.memo,
      recordDate: record.recordDate,
      createdAt: record.createdAt,
      hasMonster: record.hasMonster,
      monsterId: record.monsterId,
    );
  }

  /// Firestore → Model
  factory RecordModel.fromJson(Map<String, dynamic> json, String id) {
    return RecordModel(
      id: id,
      categoryKey: json['categoryKey'] as String,
      subCategoryKey: json['subCategoryKey'] as String,
      severity: json['severity'] as int,
      memo: json['memo'] as String?,
      recordDate: json['recordDate'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      hasMonster: json['hasMonster'] as bool? ?? false,
      monsterId: json['monsterId'] as String?,
    );
  }

  /// Model → Entity
  Record toEntity() {
    return Record(
      id: id,
      categoryKey: categoryKey,
      subCategoryKey: subCategoryKey,
      severity: severity,
      memo: memo,
      recordDate: recordDate,
      createdAt: createdAt,
      hasMonster: hasMonster,
      monsterId: monsterId,
    );
  }

  /// Model → Firestore (생성용)
  Map<String, dynamic> toJson() {
    return {
      'categoryKey': categoryKey,
      'subCategoryKey': subCategoryKey,
      'severity': severity,
      'memo': memo,
      'recordDate': recordDate,
      'createdAt': FieldValue.serverTimestamp(),
      'hasMonster': hasMonster,
      'monsterId': monsterId,
    };
  }

  /// Model → Firestore (수정용, 서버 타임스탬프 제외)
  Map<String, dynamic> toUpdateJson() {
    return {
      'categoryKey': categoryKey,
      'subCategoryKey': subCategoryKey,
      'severity': severity,
      'memo': memo,
      'hasMonster': hasMonster,
      'monsterId': monsterId,
    };
  }
}
