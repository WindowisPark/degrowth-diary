import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/record_provider.dart';
import '../../../providers/user_provider.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_indicator.dart';

/// 홈 화면
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakCount = ref.watch(streakCountProvider);
    final todayRecords = ref.watch(todayRecordsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: 마이페이지로 이동
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 스트릭 표시
            _StreakBanner(streakCount: streakCount),

            // 오늘 기록 목록
            Expanded(
              child: todayRecords.when(
                data: (records) {
                  if (records.isEmpty) {
                    return const _EmptyRecordView();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(record.subCategoryKey),
                          subtitle: Text('심각도: ${record.severity}'),
                          trailing: record.hasMonster
                              ? const Icon(Icons.pets, color: AppColors.primary)
                              : null,
                        ),
                      );
                    },
                  );
                },
                loading: () => const LoadingIndicator(),
                error: (error, _) => ErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(todayRecordsStreamProvider),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: 기록 화면으로 이동
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addRecord),
      ),
    );
  }
}

/// 스트릭 배너 - 네온 스타일
class _StreakBanner extends StatelessWidget {
  final int streakCount;

  const _StreakBanner({required this.streakCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surface,
            AppColors.surfaceLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$streakCount${AppStrings.streakDays}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '연속 기록 달성!',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.bolt,
                  color: AppColors.primary,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'STREAK',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
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

/// 빈 기록 뷰 - 네온 스타일
class _EmptyRecordView extends StatelessWidget {
  const _EmptyRecordView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 48,
              color: AppColors.textHint.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            AppStrings.noRecordsToday,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '나쁜 습관을 기록하고\n몬스터를 만나보세요!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
