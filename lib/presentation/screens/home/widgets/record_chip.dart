import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/category_data.dart';
import '../../../../domain/entities/record.dart';

/// 기록 칩 - 횡스크롤 리스트용
class RecordChip extends StatelessWidget {
  final Record record;
  final VoidCallback? onTap;

  const RecordChip({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final category = Categories.getByKey(record.categoryKey);
    final color = category?.color ?? AppColors.textHint;
    final icon = category?.icon ?? Icons.help_outline;
    final label = category?.label ?? record.categoryKey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 카테고리 아이콘
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            // 라벨
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // 심각도 표시
            _SeverityDots(severity: record.severity),
          ],
        ),
      ),
    );
  }
}

/// 심각도 점 표시
class _SeverityDots extends StatelessWidget {
  final int severity;

  const _SeverityDots({required this.severity});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isActive = index < severity;
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? _getSeverityColor(severity)
                : AppColors.border.withOpacity(0.5),
          ),
        );
      }),
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
}

/// 추가 기록 수 칩 (... +2)
class MoreRecordsChip extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const MoreRecordsChip({
    super.key,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '+$count',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '더보기',
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
