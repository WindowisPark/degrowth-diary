import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_data.dart';
import '../../../domain/entities/record.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/user_provider.dart';

/// 통계/분석 화면
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _selectedPeriod = 7; // 7일, 30일, 전체

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '통계',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 기간 선택
            _PeriodSelector(
              selected: _selectedPeriod,
              onChanged: (period) => setState(() => _selectedPeriod = period),
            ),

            const SizedBox(height: 24),

            // 요약 카드들
            _SummaryCards(period: _selectedPeriod),

            const SizedBox(height: 24),

            // 카테고리별 분포 (파이 차트)
            _CategoryDistribution(period: _selectedPeriod),

            const SizedBox(height: 24),

            // 일별 추이 (라인 차트)
            _DailyTrend(period: _selectedPeriod),

            const SizedBox(height: 24),

            // 자주 기록한 항목 TOP 5
            _TopSubCategories(period: _selectedPeriod),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// 기간 선택
class _PeriodSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _PeriodSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PeriodChip(label: '7일', value: 7, selected: selected, onTap: onChanged),
        const SizedBox(width: 8),
        _PeriodChip(label: '30일', value: 30, selected: selected, onTap: onChanged),
        const SizedBox(width: 8),
        _PeriodChip(label: '전체', value: 0, selected: selected, onTap: onChanged),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final int value;
  final int selected;
  final ValueChanged<int> onTap;

  const _PeriodChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;

    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// 통계 데이터 프로바이더
final _statsDataProvider = FutureProvider.family<_StatsData, int>((ref, period) async {
  final recordRepo = ref.watch(recordRepositoryProvider);

  DateTime start;
  final end = DateTime.now();

  if (period == 0) {
    start = DateTime(2024, 1, 1); // 전체
  } else {
    start = end.subtract(Duration(days: period));
  }

  final records = await recordRepo.getRecordsByDateRange(start, end);

  return _StatsData.fromRecords(records, period);
});

class _StatsData {
  final int totalRecords;
  final double avgSeverity;
  final Map<String, int> categoryCount;
  final Map<String, int> dailyCount;
  final Map<String, int> subCategoryCount;
  final int period;

  _StatsData({
    required this.totalRecords,
    required this.avgSeverity,
    required this.categoryCount,
    required this.dailyCount,
    required this.subCategoryCount,
    required this.period,
  });

  factory _StatsData.fromRecords(List<Record> records, int period) {
    final categoryCount = <String, int>{};
    final dailyCount = <String, int>{};
    final subCategoryCount = <String, int>{};
    var totalSeverity = 0;

    for (final record in records) {
      categoryCount[record.categoryKey] = (categoryCount[record.categoryKey] ?? 0) + 1;
      dailyCount[record.recordDate] = (dailyCount[record.recordDate] ?? 0) + 1;
      final subKey = '${record.categoryKey}:${record.subCategoryKey}';
      subCategoryCount[subKey] = (subCategoryCount[subKey] ?? 0) + 1;
      totalSeverity += record.severity;
    }

    return _StatsData(
      totalRecords: records.length,
      avgSeverity: records.isEmpty ? 0 : totalSeverity / records.length,
      categoryCount: categoryCount,
      dailyCount: dailyCount,
      subCategoryCount: subCategoryCount,
      period: period,
    );
  }
}

/// 요약 카드들
class _SummaryCards extends ConsumerWidget {
  final int period;

  const _SummaryCards({required this.period});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(_statsDataProvider(period));
    final streakCount = ref.watch(streakCountProvider);

    return statsAsync.when(
      data: (stats) {
        return Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.edit_note,
                label: '총 기록',
                value: '${stats.totalRecords}',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.local_fire_department,
                label: '스트릭',
                value: '$streakCount일',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.speed,
                label: '평균 심각도',
                value: stats.avgSeverity.toStringAsFixed(1),
                color: _getSeverityColor(stats.avgSeverity.round()),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(height: 80),
      error: (_, __) => const SizedBox(height: 80),
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
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// 카테고리별 분포 (파이 차트)
class _CategoryDistribution extends ConsumerWidget {
  final int period;

  const _CategoryDistribution({required this.period});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(_statsDataProvider(period));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '카테고리별 분포',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          statsAsync.when(
            data: (stats) {
              if (stats.categoryCount.isEmpty) {
                return const SizedBox(
                  height: 150,
                  child: Center(
                    child: Text('데이터가 없습니다', style: TextStyle(color: AppColors.textHint)),
                  ),
                );
              }

              final sections = stats.categoryCount.entries.map((e) {
                final category = Categories.getByKey(e.key);
                return PieChartSectionData(
                  value: e.value.toDouble(),
                  title: '${e.value}',
                  color: category?.color ?? AppColors.textHint,
                  radius: 50,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();

              return Row(
                children: [
                  // 파이 차트
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // 범례
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: stats.categoryCount.entries.map((e) {
                        final category = Categories.getByKey(e.key);
                        final percentage = (e.value / stats.totalRecords * 100).round();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: category?.color ?? AppColors.textHint,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  category?.label ?? e.key,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Text(
                                '$percentage%',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox(height: 150),
            error: (_, __) => const SizedBox(height: 150),
          ),
        ],
      ),
    );
  }
}

/// 일별 추이 (라인 차트)
class _DailyTrend extends ConsumerWidget {
  final int period;

  const _DailyTrend({required this.period});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(_statsDataProvider(period));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '일별 기록 추이',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          statsAsync.when(
            data: (stats) {
              if (stats.dailyCount.isEmpty) {
                return const SizedBox(
                  height: 150,
                  child: Center(
                    child: Text('데이터가 없습니다', style: TextStyle(color: AppColors.textHint)),
                  ),
                );
              }

              final days = period == 0 ? 30 : period;
              final spots = <FlSpot>[];
              final now = DateTime.now();

              for (var i = days - 1; i >= 0; i--) {
                final date = now.subtract(Duration(days: i));
                final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                final count = stats.dailyCount[dateStr] ?? 0;
                spots.add(FlSpot((days - 1 - i).toDouble(), count.toDouble()));
              }

              final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

              return SizedBox(
                height: 150,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY > 0 ? (maxY / 4).ceilToDouble() : 1,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: AppColors.border,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            if (value == value.roundToDouble()) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 10,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: (days / 5).ceilToDouble(),
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < days) {
                              final date = now.subtract(Duration(days: days - 1 - index));
                              return Text(
                                '${date.month}/${date.day}',
                                style: TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 10,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withAlpha(30),
                        ),
                      ),
                    ],
                    minY: 0,
                    maxY: maxY > 0 ? maxY + 1 : 5,
                  ),
                ),
              );
            },
            loading: () => const SizedBox(height: 150),
            error: (_, __) => const SizedBox(height: 150),
          ),
        ],
      ),
    );
  }
}

/// 자주 기록한 항목 TOP 5
class _TopSubCategories extends ConsumerWidget {
  final int period;

  const _TopSubCategories({required this.period});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(_statsDataProvider(period));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '자주 기록한 항목 TOP 5',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          statsAsync.when(
            data: (stats) {
              if (stats.subCategoryCount.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text('데이터가 없습니다', style: TextStyle(color: AppColors.textHint)),
                  ),
                );
              }

              // TOP 5 정렬
              final sorted = stats.subCategoryCount.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));
              final top5 = sorted.take(5).toList();
              final maxCount = top5.first.value;

              return Column(
                children: top5.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final parts = item.key.split(':');
                  final categoryKey = parts[0];
                  final subCategoryKey = parts[1];

                  final category = Categories.getByKey(categoryKey);
                  final subCategory = category?.subCategories
                      .where((s) => s.key == subCategoryKey)
                      .firstOrNull;
                  final color = category?.color ?? AppColors.textHint;
                  final progress = item.value / maxCount;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        // 순위
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: index == 0 ? AppColors.primary : AppColors.textHint,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // 이모지
                        Text(
                          subCategory?.emoji ?? '📝',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        // 이름 + 바
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subCategory?.label ?? subCategoryKey,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: AppColors.border,
                                  valueColor: AlwaysStoppedAnimation(color),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 횟수
                        Text(
                          '${item.value}회',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox(height: 100),
            error: (_, __) => const SizedBox(height: 100),
          ),
        ],
      ),
    );
  }
}
