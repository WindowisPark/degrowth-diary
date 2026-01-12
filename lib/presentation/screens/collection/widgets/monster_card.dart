import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/category_data.dart';
import '../../../../core/utils/image_loader.dart';
import '../../../../domain/entities/monster.dart';
import '../../../../domain/entities/user_monster.dart';

/// 몬스터 카드 (도감용)
class MonsterCard extends StatelessWidget {
  final Monster monster;
  final UserMonster? userMonster;
  final VoidCallback onTap;

  const MonsterCard({
    super.key,
    required this.monster,
    this.userMonster,
    required this.onTap,
  });

  bool get isOwned => userMonster != null;

  @override
  Widget build(BuildContext context) {
    final category = Categories.getByKey(monster.attribute);
    final color = category?.color ?? AppColors.textHint;
    final rarityColor = _getRarityColor(monster.rarity);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isOwned ? AppColors.surface : AppColors.surface.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOwned ? rarityColor.withAlpha(150) : AppColors.border,
            width: isOwned ? 2 : 1,
          ),
          boxShadow: isOwned
              ? [
                  BoxShadow(
                    color: rarityColor.withAlpha(40),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // 몬스터 이미지 영역
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isOwned
                      ? color.withAlpha(20)
                      : AppColors.background.withAlpha(150),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: Stack(
                  children: [
                    // 몬스터 이미지 또는 실루엣
                    Center(
                      child: isOwned
                          ? _MonsterImage(monster: monster, color: color)
                          : _LockedMonster(),
                    ),

                    // 레어도 뱃지
                    if (isOwned)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: _RarityBadge(rarity: monster.rarity),
                      ),

                    // 레벨 (획득 시)
                    if (isOwned && userMonster != null)
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background.withAlpha(200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Lv.${userMonster!.level}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 이름 영역
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isOwned ? monster.name : '???',
                      style: TextStyle(
                        color: isOwned
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(String rarity) {
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
}

/// 몬스터 이미지
class _MonsterImage extends StatelessWidget {
  final Monster monster;
  final Color color;

  const _MonsterImage({required this.monster, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageLoader.loadMonsterImage(
      monster.imageUrl,
      width: 50,
      height: 50,
      fit: BoxFit.contain,
      fallbackColor: color,
    );
  }
}

/// 잠긴 몬스터
class _LockedMonster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.border.withAlpha(50),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.lock,
        color: AppColors.textHint,
        size: 24,
      ),
    );
  }
}

/// 레어도 뱃지
class _RarityBadge extends StatelessWidget {
  final String rarity;

  const _RarityBadge({required this.rarity});

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final label = _getLabel();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(100), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.bold,
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
        return 'C';
      case 'rare':
        return 'R';
      case 'epic':
        return 'E';
      case 'legendary':
        return 'L';
      default:
        return 'C';
    }
  }
}
