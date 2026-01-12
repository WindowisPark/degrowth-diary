import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/category_data.dart';
import '../../../../providers/record_provider.dart';

/// 빠른 선택 스텝 - 카테고리 탭 + 최근 기록 + 소분류 리스트
class QuickSelectStep extends ConsumerStatefulWidget {
  final void Function(CategoryData category, SubCategoryData subCategory) onSelected;

  const QuickSelectStep({
    super.key,
    required this.onSelected,
  });

  @override
  ConsumerState<QuickSelectStep> createState() => _QuickSelectStepState();
}

class _QuickSelectStepState extends ConsumerState<QuickSelectStep>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0; // 0 = 전체

  @override
  void initState() {
    super.initState();
    // 전체 + 카테고리 수
    _tabController = TabController(
      length: Categories.all.length + 1,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTabIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SubCategoryData> _getFilteredSubCategories() {
    if (_selectedTabIndex == 0) {
      // 전체: 모든 카테고리의 소분류
      return Categories.all.expand((c) => c.subCategories).toList();
    } else {
      // 특정 카테고리
      return Categories.all[_selectedTabIndex - 1].subCategories;
    }
  }

  CategoryData _getCategoryForSub(SubCategoryData sub) {
    return Categories.all.firstWhere(
      (c) => c.subCategories.contains(sub),
      orElse: () => Categories.all.last,
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentItems = ref.watch(recentSubCategoriesProvider);
    final filteredSubs = _getFilteredSubCategories();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 타이틀
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '오늘 뭐 망했어?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '바로 선택하거나 카테고리를 필터링하세요',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 최근 기록 (있을 때만)
        if (recentItems.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '최근 기록',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: recentItems.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = recentItems[index];
                final category = Categories.getByKey(item.categoryKey);
                final sub = Categories.getSubByKey(item.categoryKey, item.subCategoryKey);
                if (category == null || sub == null) return const SizedBox();

                return _RecentChip(
                  subCategory: sub,
                  color: category.color,
                  onTap: () => widget.onSelected(category, sub),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],

        // 카테고리 탭
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          dividerColor: Colors.transparent,
          tabs: [
            const Tab(text: '전체'),
            ...Categories.all.map((c) => Tab(text: c.label)),
          ],
        ),

        const SizedBox(height: 8),

        // 소분류 리스트
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            itemCount: filteredSubs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final sub = filteredSubs[index];
              final category = _getCategoryForSub(sub);

              return _SubCategoryTile(
                subCategory: sub,
                category: category,
                showCategoryBadge: _selectedTabIndex == 0,
                onTap: () => widget.onSelected(category, sub),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 최근 기록 칩
class _RecentChip extends StatelessWidget {
  final SubCategoryData subCategory;
  final Color color;
  final VoidCallback onTap;

  const _RecentChip({
    required this.subCategory,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: color.withAlpha(80),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subCategory.emoji != null) ...[
              Text(subCategory.emoji!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
            ],
            Text(
              subCategory.label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 소분류 타일
class _SubCategoryTile extends StatelessWidget {
  final SubCategoryData subCategory;
  final CategoryData category;
  final bool showCategoryBadge;
  final VoidCallback onTap;

  const _SubCategoryTile({
    required this.subCategory,
    required this.category,
    required this.showCategoryBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // 이모지
            if (subCategory.emoji != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: category.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    subCategory.emoji!,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 14),
            ],

            // 라벨
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subCategory.label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (showCategoryBadge) ...[
                    const SizedBox(height: 4),
                    Text(
                      category.label,
                      style: TextStyle(
                        color: category.color,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // 화살표
            Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
