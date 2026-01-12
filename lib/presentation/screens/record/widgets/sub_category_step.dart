import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/category_data.dart';

/// Step 2: 소분류 선택
class SubCategoryStep extends StatelessWidget {
  final CategoryData? category;
  final void Function(SubCategoryData) onSelected;

  const SubCategoryStep({
    super.key,
    required this.category,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (category == null) {
      return const Center(
        child: Text('카테고리를 먼저 선택해주세요'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // 선택된 카테고리 표시
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: category!.color.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category!.icon,
                  color: category!.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                category!.label,
                style: TextStyle(
                  color: category!.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 타이틀
          const Text(
            '어떤 거야?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '세부 항목을 선택해주세요',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),

          // 소분류 리스트
          Expanded(
            child: ListView.separated(
              itemCount: category!.subCategories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final sub = category!.subCategories[index];
                return _SubCategoryTile(
                  subCategory: sub,
                  color: category!.color,
                  onTap: () => onSelected(sub),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 소분류 타일
class _SubCategoryTile extends StatelessWidget {
  final SubCategoryData subCategory;
  final Color color;
  final VoidCallback onTap;

  const _SubCategoryTile({
    required this.subCategory,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // 이모지
            if (subCategory.emoji != null) ...[
              Text(
                subCategory.emoji!,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 16),
            ],
            // 라벨
            Expanded(
              child: Text(
                subCategory.label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // 화살표
            Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
