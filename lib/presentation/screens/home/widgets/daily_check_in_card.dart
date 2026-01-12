import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../providers/user_provider.dart';
import '../../record/record_flow_screen.dart';

/// 데일리 체크인 카드
class DailyCheckInCard extends ConsumerWidget {
  const DailyCheckInCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCheckedIn = ref.watch(isTodayCheckedInProvider);
    final streakCount = ref.watch(streakCountProvider);

    if (isCheckedIn) {
      // 체크인 완료 상태
      return _CheckInCompletedCard(streakCount: streakCount);
    } else {
      // 체크인 필요
      return _CheckInPromptCard(
        onCheckIn: () async {
          await ref.read(userNotifierProvider.notifier).dailyCheckIn(
                AppDateUtils.todayRecordDate,
              );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('오늘 체크인 완료! 🎉'),
                backgroundColor: AppColors.success,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        onRecord: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const RecordFlowScreen(),
              fullscreenDialog: true,
            ),
          );
        },
      );
    }
  }
}

/// 체크인 완료 카드
class _CheckInCompletedCard extends StatelessWidget {
  final int streakCount;

  const _CheckInCompletedCard({required this.streakCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 체크 아이콘
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          // 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘 체크인 완료!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$streakCount일 연속',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 이모지
          const Text(
            '🎉',
            style: TextStyle(fontSize: 32),
          ),
        ],
      ),
    );
  }
}

/// 체크인 유도 카드
class _CheckInPromptCard extends StatelessWidget {
  final VoidCallback onCheckIn;
  final VoidCallback onRecord;

  const _CheckInPromptCard({
    required this.onCheckIn,
    required this.onRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀
          const Row(
            children: [
              Icon(
                Icons.waving_hand,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                '오늘 어땠어요?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 버튼들
          Row(
            children: [
              Expanded(
                child: _CheckInButton(
                  icon: '😊',
                  label: '괜찮았어요',
                  onTap: onCheckIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CheckInButton(
                  icon: '😅',
                  label: '망했어요',
                  onTap: onRecord,
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 체크인 버튼
class _CheckInButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _CheckInButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary
          ? AppColors.primary.withOpacity(0.15)
          : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
