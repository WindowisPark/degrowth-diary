import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/record.dart';
import '../../../../providers/record_provider.dart';
import 'record_chip.dart';

/// 오늘의 기록 섹션
class TodayRecordsSection extends ConsumerWidget {
  final VoidCallback? onMoreTap;

  const TodayRecordsSection({
    super.key,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayRecords = ref.watch(todayRecordsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: todayRecords.when(
            data: (records) => _SectionHeader(
              count: records.length,
              onMoreTap: records.isNotEmpty ? onMoreTap : null,
            ),
            loading: () => const _SectionHeader(count: 0),
            error: (_, __) => const _SectionHeader(count: 0),
          ),
        ),

        // 기록 리스트
        SizedBox(
          height: 100,
          child: todayRecords.when(
            data: (records) {
              if (records.isEmpty) {
                return const _EmptyRecords();
              }
              return _RecordsList(
                records: records,
                onMoreTap: onMoreTap,
              );
            },
            loading: () => const _LoadingRecords(),
            error: (_, __) => const _EmptyRecords(),
          ),
        ),
      ],
    );
  }
}

/// 섹션 헤더
class _SectionHeader extends StatelessWidget {
  final int count;
  final VoidCallback? onMoreTap;

  const _SectionHeader({
    required this.count,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              '오늘의 퇴화',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: count > 0
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: count > 0 ? AppColors.primary : AppColors.textHint,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        if (onMoreTap != null)
          GestureDetector(
            onTap: onMoreTap,
            child: Row(
              children: [
                Text(
                  '더보기',
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textHint,
                  size: 18,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// 기록 리스트
class _RecordsList extends StatelessWidget {
  final List<Record> records;
  final VoidCallback? onMoreTap;

  const _RecordsList({
    required this.records,
    this.onMoreTap,
  });

  static const int _maxDisplay = 4;

  @override
  Widget build(BuildContext context) {
    final displayRecords = records.take(_maxDisplay).toList();
    final remainingCount = records.length - _maxDisplay;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: displayRecords.length + (remainingCount > 0 ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        if (index == displayRecords.length && remainingCount > 0) {
          return MoreRecordsChip(
            count: remainingCount,
            onTap: onMoreTap,
          );
        }
        return RecordChip(
          record: displayRecords[index],
          onTap: () {
            // TODO: 기록 상세 또는 편집
          },
        );
      },
    );
  }
}

/// 빈 기록
class _EmptyRecords extends StatelessWidget {
  const _EmptyRecords();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_note,
              color: AppColors.textHint,
              size: 24,
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '아직 기록이 없어요',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '오늘 뭐 망했어?',
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 로딩 상태
class _LoadingRecords extends StatelessWidget {
  const _LoadingRecords();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => Container(
        width: 72,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
