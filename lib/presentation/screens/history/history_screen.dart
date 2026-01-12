import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_data.dart';
import '../../../domain/entities/record.dart';
import '../../../providers/repository_providers.dart';

/// 기록 히스토리 화면
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String? _selectedCategory; // null = 전체
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '기록 히스토리',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 월 선택 + 카테고리 필터
          _FilterSection(
            selectedMonth: _selectedMonth,
            selectedCategory: _selectedCategory,
            onMonthChanged: (month) => setState(() => _selectedMonth = month),
            onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
          ),

          // 기록 리스트
          Expanded(
            child: _RecordList(
              month: _selectedMonth,
              categoryFilter: _selectedCategory,
            ),
          ),
        ],
      ),
    );
  }
}

/// 필터 섹션
class _FilterSection extends StatelessWidget {
  final DateTime selectedMonth;
  final String? selectedCategory;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<String?> onCategoryChanged;

  const _FilterSection({
    required this.selectedMonth,
    required this.selectedCategory,
    required this.onMonthChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 월 선택
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
                onPressed: () {
                  onMonthChanged(DateTime(selectedMonth.year, selectedMonth.month - 1));
                },
              ),
              GestureDetector(
                onTap: () => _showMonthPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${selectedMonth.year}년 ${selectedMonth.month}월',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                onPressed: () {
                  final next = DateTime(selectedMonth.year, selectedMonth.month + 1);
                  if (!next.isAfter(DateTime.now())) {
                    onMonthChanged(next);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 카테고리 필터
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _CategoryChip(
                  label: '전체',
                  isSelected: selectedCategory == null,
                  onTap: () => onCategoryChanged(null),
                ),
                ...Categories.all.map((cat) => _CategoryChip(
                  label: cat.label,
                  color: cat.color,
                  isSelected: selectedCategory == cat.key,
                  onTap: () => onCategoryChanged(cat.key),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMonthPicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2024, 1),
      lastDate: now,
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onMonthChanged(DateTime(picked.year, picked.month));
    }
  }
}

/// 카테고리 필터 칩
class _CategoryChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? chipColor.withAlpha(30) : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? chipColor : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? chipColor : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

/// 기록 리스트
class _RecordList extends ConsumerWidget {
  final DateTime month;
  final String? categoryFilter;

  const _RecordList({
    required this.month,
    this.categoryFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(_monthRecordsProvider((month, categoryFilter)));

    return recordsAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: AppColors.textHint),
                const SizedBox(height: 16),
                Text(
                  '이 달의 기록이 없습니다',
                  style: TextStyle(color: AppColors.textHint, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // 날짜별로 그룹핑
        final groupedRecords = _groupByDate(records);

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: groupedRecords.length,
          itemBuilder: (context, index) {
            final entry = groupedRecords.entries.elementAt(index);
            return _DateGroup(
              date: entry.key,
              records: entry.value,
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(
        child: Text('오류: $e', style: TextStyle(color: AppColors.textHint)),
      ),
    );
  }

  Map<String, List<Record>> _groupByDate(List<Record> records) {
    final grouped = <String, List<Record>>{};
    for (final record in records) {
      final dateKey = record.recordDate;
      grouped.putIfAbsent(dateKey, () => []).add(record);
    }
    return grouped;
  }
}

/// 월별 기록 프로바이더
final _monthRecordsProvider = FutureProvider.family<List<Record>, (DateTime, String?)>((ref, params) async {
  final (month, categoryFilter) = params;
  final recordRepo = ref.watch(recordRepositoryProvider);

  final start = DateTime(month.year, month.month, 1);
  final end = DateTime(month.year, month.month + 1, 0); // 해당 월의 마지막 날

  var records = await recordRepo.getRecordsByDateRange(start, end);

  // 카테고리 필터 적용
  if (categoryFilter != null) {
    records = records.where((r) => r.categoryKey == categoryFilter).toList();
  }

  return records;
});

/// 날짜 그룹
class _DateGroup extends StatelessWidget {
  final String date;
  final List<Record> records;

  const _DateGroup({
    required this.date,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    final parts = date.split('-');
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    final weekday = _getWeekday(DateTime.parse(date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 날짜 헤더
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            children: [
              Text(
                '$month월 $day일',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                weekday,
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${records.length}건',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 기록 카드들
        ...records.map((record) => _RecordCard(record: record)),

        const SizedBox(height: 8),
      ],
    );
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return '${weekdays[date.weekday - 1]}요일';
  }
}

/// 기록 카드
class _RecordCard extends StatelessWidget {
  final Record record;

  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final category = Categories.getByKey(record.categoryKey);
    final subCategory = category?.subCategories
        .where((s) => s.key == record.subCategoryKey)
        .firstOrNull;
    final color = category?.color ?? AppColors.textHint;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // 카테고리 아이콘
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                subCategory?.emoji ?? '📝',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      subCategory?.label ?? record.subCategoryKey,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category?.label ?? '',
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (record.memo != null && record.memo!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    record.memo!,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // 심각도
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < record.severity
                          ? _getSeverityColor(record.severity)
                          : AppColors.border,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(record.createdAt),
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(int severity) {
    switch (severity) {
      case 1:
        return AppColors.severity1;
      case 2:
        return AppColors.severity2;
      case 3:
        return AppColors.severity3;
      case 4:
        return AppColors.severity4;
      case 5:
        return AppColors.severity5;
      default:
        return AppColors.textHint;
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
