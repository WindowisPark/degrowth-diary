import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../collection/collection_screen.dart';
import '../history/history_screen.dart';
import '../record/record_flow_screen.dart';
import '../stats/stats_screen.dart';
import 'widgets/daily_check_in_card.dart';
import 'widgets/monster_habitat.dart';
import 'widgets/special_monster_hint_card.dart';
import 'widgets/today_records_section.dart';

/// 홈 화면 - 몬스터 서식지 스타일
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // 1. 미니멀 헤더
                      const _HomeHeader(),

                      // 2. 데일리 체크인 카드
                      const DailyCheckInCard(),

                      // 3. 오늘의 특별 몬스터
                      const SpecialMonsterHintCard(),

                      // 4. 몬스터 서식지 (메인 영역)
                      const Expanded(
                        flex: 5,
                        child: MonsterHabitat(),
                      ),

                      const SizedBox(height: 12),

                      // 5. 오늘의 기록 섹션
                      SizedBox(
                        height: 140,
                        child: TodayRecordsSection(
                          onMoreTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const HistoryScreen()),
                            );
                          },
                        ),
                      ),

                      // 4. 하단 CTA
                      _RecordButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RecordFlowScreen(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 미니멀 헤더
class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekday = _weekdays[now.weekday - 1];
    final formattedDate = '${now.month}월 ${now.day}일 ${weekday}요일';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 날짜
          Text(
            formattedDate,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          // 네비게이션 버튼들
          Row(
            children: [
              // 통계
              IconButton(
                icon: const Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StatsScreen()),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: '통계',
              ),
              const SizedBox(width: 12),
              // 도감
              IconButton(
                icon: const Icon(
                  Icons.catching_pokemon,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CollectionScreen()),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: '도감',
              ),
              const SizedBox(width: 12),
              // 설정
              IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  context.push(AppRoutes.settings);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: '설정',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 하단 기록하기 버튼
class _RecordButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RecordButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 24),
              SizedBox(width: 8),
              Text(
                '기록하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
