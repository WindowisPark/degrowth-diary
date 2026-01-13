import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_data.dart';
import '../../../core/constants/sample_monsters.dart';
import '../../../core/utils/image_loader.dart';
import '../../../domain/entities/monster.dart';
import '../../../domain/entities/user_monster.dart';

/// 몬스터 상세 화면
class MonsterDetailScreen extends StatelessWidget {
  final Monster monster;
  final UserMonster? userMonster;

  const MonsterDetailScreen({
    super.key,
    required this.monster,
    this.userMonster,
  });

  bool get isOwned => userMonster != null;

  @override
  Widget build(BuildContext context) {
    final category = Categories.getByKey(monster.attribute);
    final color = category?.color ?? AppColors.textHint;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 앱바 + 몬스터 이미지
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background.withAlpha(150),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withAlpha(40),
                      AppColors.surface,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // 몬스터 이미지
                      _MonsterAvatar(
                        monster: monster,
                        color: color,
                        isOwned: isOwned,
                        size: 200,
                      ),
                      const SizedBox(height: 16),
                      // 레어도
                      _RarityLabel(rarity: monster.rarity),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 컨텐츠
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름 + 카테고리
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isOwned ? monster.name : '???',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(category?.icon, color: color, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              category?.label ?? '',
                              style: TextStyle(
                                color: color,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 레벨 & 경험치 (획득 시)
                  if (isOwned && userMonster != null) ...[
                    _LevelSection(userMonster: userMonster!, color: color),
                    const SizedBox(height: 24),
                  ],

                  // 설명
                  _Section(
                    title: '설명',
                    child: Text(
                      isOwned ? monster.description : '???',
                      style: TextStyle(
                        color: isOwned
                            ? AppColors.textSecondary
                            : AppColors.textHint,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 획득 조건
                  _Section(
                    title: '획득 조건',
                    child: _UnlockConditionCard(
                      condition: monster.unlockCondition,
                      isOwned: isOwned,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 진화 트리
                  _Section(
                    title: '진화',
                    child: _EvolutionTree(
                      monster: monster,
                      color: color,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 몬스터 아바타
class _MonsterAvatar extends StatelessWidget {
  final Monster monster;
  final Color color;
  final bool isOwned;
  final double size;

  const _MonsterAvatar({
    required this.monster,
    required this.color,
    required this.isOwned,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOwned ? color.withAlpha(80) : AppColors.border.withAlpha(30),
        shape: BoxShape.circle,
        border: Border.all(
          color: isOwned ? color.withAlpha(80) : AppColors.border,
          width: 3,
        ),
        boxShadow: isOwned
            ? [
                BoxShadow(
                  color: color.withAlpha(50),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ]
            : null,
      ),
      child: Center(
        child: isOwned
            ? ImageLoader.loadMonsterImageById(
                monster.id,
                imageUrl: monster.imageUrl.isNotEmpty ? monster.imageUrl : null,
                width: size * 0.85,
                height: size * 0.85,
                fallback: Icon(
                  Icons.pest_control,
                  color: color,
                  size: size * 0.4,
                ),
              )
            : Icon(
                Icons.lock,
                color: AppColors.textHint,
                size: size * 0.3,
              ),
      ),
    );
  }
}

/// 레어도 라벨
class _RarityLabel extends StatelessWidget {
  final String rarity;

  const _RarityLabel({required this.rarity});

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final label = _getLabel();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(80), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Color _getColor() {
    switch (rarity) {
      case 'common':
        return AppColors.rarityCommon;
      case 'rare':
        return AppColors.rarityRare;
      case 'epic':
        return AppColors.rarityEpic;
      case 'legendary':
        return AppColors.rarityLegendary;
      default:
        return AppColors.rarityCommon;
    }
  }

  String _getLabel() {
    switch (rarity) {
      case 'common':
        return 'COMMON';
      case 'rare':
        return 'RARE';
      case 'epic':
        return 'EPIC';
      case 'legendary':
        return 'LEGENDARY';
      default:
        return 'COMMON';
    }
  }
}

/// 레벨 섹션
class _LevelSection extends StatelessWidget {
  final UserMonster userMonster;
  final Color color;

  const _LevelSection({required this.userMonster, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // 레벨
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level',
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${userMonster.level}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),

          // 경험치 바
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EXP',
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${userMonster.exp} / ${userMonster.expToNextLevel}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: userMonster.levelProgress,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 섹션
class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

/// 획득 조건 카드
class _UnlockConditionCard extends StatelessWidget {
  final UnlockCondition condition;
  final bool isOwned;

  const _UnlockConditionCard({
    required this.condition,
    required this.isOwned,
  });

  @override
  Widget build(BuildContext context) {
    final category = Categories.getByKey(condition.categoryKey);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOwned ? AppColors.primary.withAlpha(100) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (category?.color ?? AppColors.textHint).withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category?.icon ?? Icons.help_outline,
              color: category?.color ?? AppColors.textHint,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${category?.label ?? condition.categoryKey} 기록',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${condition.count}회 달성',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (isOwned)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.primary,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

/// 진화 트리
class _EvolutionTree extends StatelessWidget {
  final Monster monster;
  final Color color;

  const _EvolutionTree({required this.monster, required this.color});

  @override
  Widget build(BuildContext context) {
    // 같은 속성의 진화 라인 찾기
    final evolutionLine = SampleMonsters.getByAttribute(monster.attribute)
      ..sort((a, b) => a.stage.compareTo(b.stage));

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: evolutionLine.length,
        separatorBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Icon(
              Icons.arrow_forward,
              color: AppColors.textHint,
              size: 16,
            ),
          ),
        ),
        itemBuilder: (context, index) {
          final evo = evolutionLine[index];
          final isCurrent = evo.id == monster.id;

          return Container(
            width: 70,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCurrent ? color.withAlpha(20) : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrent ? color : AppColors.border,
                width: isCurrent ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pest_control,
                    color: color,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  evo.name,
                  style: TextStyle(
                    color: isCurrent
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
