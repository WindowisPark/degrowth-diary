import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/monster.dart';
import '../../../../providers/special_monster_provider.dart';

/// 오늘의 특별 몬스터 힌트 카드
class SpecialMonsterHintCard extends ConsumerWidget {
  const SpecialMonsterHintCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialMonster = ref.watch(todaySpecialMonsterProvider);

    if (specialMonster == null) {
      return const SizedBox.shrink(); // 특별 몬스터 없으면 표시 안 함
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getRarityColor(specialMonster.rarity).withOpacity(0.15),
            _getRarityColor(specialMonster.rarity).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getRarityColor(specialMonster.rarity).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // 아이콘
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _getRarityColor(specialMonster.rarity).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getRarityEmoji(specialMonster.rarity),
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '💡 오늘의 특별 몬스터',
                      style: TextStyle(
                        color: _getRarityColor(specialMonster.rarity),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _RarityBadge(rarity: specialMonster.rarity),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  specialMonster.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getConditionText(specialMonster),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // 화살표
          Icon(
            Icons.arrow_forward_ios,
            color: _getRarityColor(specialMonster.rarity).withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }

  /// 희귀도별 컬러
  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'legendary':
        return const Color(0xFFFFB800); // 금색
      case 'epic':
        return const Color(0xFFB24BF3); // 보라색
      case 'rare':
        return const Color(0xFF4B9EF3); // 파란색
      default:
        return AppColors.primary;
    }
  }

  /// 희귀도별 이모지
  String _getRarityEmoji(String rarity) {
    switch (rarity) {
      case 'legendary':
        return '👑';
      case 'epic':
        return '💎';
      case 'rare':
        return '⭐';
      default:
        return '✨';
    }
  }

  /// 조건 텍스트 생성
  String _getConditionText(Monster monster) {
    final condition = monster.unlockCondition;
    final parts = <String>[];

    // 시간대 조건
    if (condition.hourStart != null && condition.hourEnd != null) {
      parts.add('${condition.hourStart}시-${condition.hourEnd}시');
    }

    // 요일 조건
    if (condition.dayOfWeek != null) {
      final days = ['', '월', '화', '수', '목', '금', '토', '일'];
      parts.add('${days[condition.dayOfWeek!]}요일');
    }

    // 보너스 확률
    if (condition.bonusChance > 0) {
      final bonusPercent = (condition.bonusChance * 100).toInt();
      parts.add('획득 확률 +$bonusPercent%');
    }

    return parts.isEmpty ? '지금 획득 가능!' : parts.join(' • ');
  }
}

/// 희귀도 뱃지
class _RarityBadge extends StatelessWidget {
  final String rarity;

  const _RarityBadge({required this.rarity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _getColor().withOpacity(0.4),
          width: 0.5,
        ),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          color: _getColor(),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getColor() {
    switch (rarity) {
      case 'legendary':
        return const Color(0xFFFFB800);
      case 'epic':
        return const Color(0xFFB24BF3);
      case 'rare':
        return const Color(0xFF4B9EF3);
      default:
        return AppColors.primary;
    }
  }

  String _getLabel() {
    switch (rarity) {
      case 'legendary':
        return '전설';
      case 'epic':
        return '영웅';
      case 'rare':
        return '희귀';
      default:
        return '일반';
    }
  }
}
