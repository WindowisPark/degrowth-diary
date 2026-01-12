import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/category_data.dart';
import '../../../../domain/entities/monster.dart';

/// 기록 완료 다이얼로그
class RecordCompleteDialog extends StatefulWidget {
  final CategoryData category;
  final SubCategoryData subCategory;
  final int severity;
  final Monster? unlockedMonster; // 새로 획득한 몬스터
  final VoidCallback onClose;

  const RecordCompleteDialog({
    super.key,
    required this.category,
    required this.subCategory,
    required this.severity,
    this.unlockedMonster,
    required this.onClose,
  });

  @override
  State<RecordCompleteDialog> createState() => _RecordCompleteDialogState();
}

class _RecordCompleteDialogState extends State<RecordCompleteDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.category.color;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withAlpha(100),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(50),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 성공 아이콘 또는 몬스터 아이콘
              if (widget.unlockedMonster != null)
                _MonsterUnlockDisplay(monster: widget.unlockedMonster!, color: color)
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: color,
                    size: 48,
                  ),
                ),

              const SizedBox(height: 24),

              // 타이틀 - 몬스터 획득 시 다른 메시지
              Text(
                widget.unlockedMonster != null ? '몬스터 등장!' : '기록 완료!',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // 기록 내용
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.subCategory.emoji ?? '',
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.subCategory.label,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '심각도 ',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            ...List.generate(5, (i) {
                              return Icon(
                                Icons.circle,
                                size: 8,
                                color: i < widget.severity
                                    ? _getSeverityColor(widget.severity)
                                    : AppColors.border,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 응원 메시지 또는 몬스터 설명
              Text(
                widget.unlockedMonster != null
                    ? widget.unlockedMonster!.description
                    : _getEncouragingMessage(widget.severity),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontStyle: widget.unlockedMonster != null
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              ),

              const SizedBox(height: 24),

              // 확인 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

  String _getEncouragingMessage(int severity) {
    switch (severity) {
      case 1:
        return '가벼운 실수는 누구나 해요!';
      case 2:
        return '인정하는 것만으로도 대단해요';
      case 3:
        return '오늘 하루도 고생했어요';
      case 4:
        return '다음엔 조금만 더 조심해봐요';
      case 5:
        return '...그래도 기록했으니 된 거예요';
      default:
        return '기록 완료!';
    }
  }
}

/// 몬스터 획득 디스플레이
class _MonsterUnlockDisplay extends StatelessWidget {
  final Monster monster;
  final Color color;

  const _MonsterUnlockDisplay({
    required this.monster,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 몬스터 아바타 (빛나는 효과)
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(30),
            border: Border.all(
              color: color.withAlpha(150),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(80),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: monster.imageUrl.isNotEmpty
                ? Image.network(
                    monster.imageUrl,
                    width: 60,
                    height: 60,
                    errorBuilder: (_, __, ___) => _defaultIcon(),
                  )
                : _defaultIcon(),
          ),
        ),

        const SizedBox(height: 12),

        // 몬스터 이름
        Text(
          monster.name,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        // 레어도 뱃지
        _RarityBadge(rarity: monster.rarity),
      ],
    );
  }

  Widget _defaultIcon() {
    return Icon(
      Icons.pest_control,
      color: color,
      size: 50,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
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
