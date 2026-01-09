import 'package:equatable/equatable.dart';

/// 기록 엔티티
class Record extends Equatable {
  final String id;
  final String categoryKey;
  final String subCategoryKey;
  final int severity;
  final String? memo;
  final String recordDate;
  final DateTime createdAt;
  final bool hasMonster;
  final String? monsterId;

  const Record({
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

  Record copyWith({
    String? id,
    String? categoryKey,
    String? subCategoryKey,
    int? severity,
    String? memo,
    String? recordDate,
    DateTime? createdAt,
    bool? hasMonster,
    String? monsterId,
  }) {
    return Record(
      id: id ?? this.id,
      categoryKey: categoryKey ?? this.categoryKey,
      subCategoryKey: subCategoryKey ?? this.subCategoryKey,
      severity: severity ?? this.severity,
      memo: memo ?? this.memo,
      recordDate: recordDate ?? this.recordDate,
      createdAt: createdAt ?? this.createdAt,
      hasMonster: hasMonster ?? this.hasMonster,
      monsterId: monsterId ?? this.monsterId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        categoryKey,
        subCategoryKey,
        severity,
        memo,
        recordDate,
        createdAt,
        hasMonster,
        monsterId,
      ];
}
