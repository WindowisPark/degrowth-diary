import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/achievement_definitions.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/achievement.dart';
import '../../../providers/achievement_provider.dart';
import 'widgets/achievement_card.dart';

/// 업적 화면
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAchievementsAsync = ref.watch(userAchievementsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('업적'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: userAchievementsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Text(
            '오류가 발생했습니다',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (userAchievements) {
          // 전체 업적 목록
          final allAchievements = AchievementDefinitions.all;

          // 획득한 업적 수
          final unlockedCount = userAchievements.where((ua) => ua.isUnlocked).length;
          final totalCount = allAchievements.length;

          return Column(
            children: [
              // 상단 통계
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$unlockedCount / $totalCount',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '획득',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: AppColors.border),

              // 업적 그리드
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: allAchievements.length,
                  itemBuilder: (context, index) {
                    final achievementDef = allAchievements[index];

                    // 해당 업적의 유저 진행 상황 찾기
                    final userAchievement = userAchievements.firstWhere(
                      (ua) => ua.achievementId == achievementDef.id,
                      orElse: () => UserAchievement(achievementId: achievementDef.id),
                    );

                    return AchievementCard(
                      definition: achievementDef,
                      userAchievement: userAchievement,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
