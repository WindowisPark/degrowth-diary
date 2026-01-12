import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/achievement.dart';

/// 업적 카드 위젯
class AchievementCard extends StatelessWidget {
  final Achievement definition;
  final UserAchievement? userAchievement;

  const AchievementCard({
    super.key,
    required this.definition,
    this.userAchievement,
  });

  bool get isUnlocked => userAchievement?.isUnlocked ?? false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surface : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? AppColors.primary.withOpacity(0.3) : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            Text(
              definition.iconEmoji,
              style: TextStyle(
                fontSize: 48,
                height: 1.2,
                color: isUnlocked ? null : Colors.white.withOpacity(0.2),
              ),
            ),
            const SizedBox(height: 12),

            // 제목
            Text(
              definition.title,
              style: TextStyle(
                color: isUnlocked ? AppColors.textPrimary : AppColors.textHint,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // 설명
            Text(
              definition.description,
              style: TextStyle(
                color: isUnlocked ? AppColors.textSecondary : AppColors.textHint,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // 획득일 (획득한 경우만)
            if (isUnlocked && userAchievement!.unlockedAt != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DateFormat('yyyy.MM.dd').format(userAchievement!.unlockedAt!),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],

            // 미획득 표시
            if (!isUnlocked) ...[
              const SizedBox(height: 12),
              Icon(
                Icons.lock_outline,
                size: 20,
                color: AppColors.textHint.withOpacity(0.5),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
