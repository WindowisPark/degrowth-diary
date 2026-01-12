import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/sample_monsters.dart';
import '../../../domain/entities/monster.dart';
import '../../../domain/entities/user_monster.dart';
import '../../../providers/user_monster_provider.dart';
import 'widgets/monster_card.dart';
import 'monster_detail_screen.dart';

/// 몬스터 도감 화면
class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 탭: 전체 + 카테고리별
  final List<String> _tabs = ['전체', '식습관', '수면', '운동', '소비', '생산성'];
  final List<String?> _tabAttributes = [null, 'food', 'sleep', 'exercise', 'money', 'productivity'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myMonsters = ref.watch(myMonstersStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '도감',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          labelPadding: const EdgeInsets.symmetric(horizontal: 14),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          dividerColor: Colors.transparent,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: myMonsters.when(
        data: (userMonsters) {
          return TabBarView(
            controller: _tabController,
            children: _tabAttributes.map((attr) {
              return _MonsterGrid(
                attribute: attr,
                userMonsters: userMonsters,
                onMonsterTap: _onMonsterTap,
              );
            }).toList(),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (_, __) => const Center(
          child: Text('몬스터를 불러오는데 실패했습니다'),
        ),
      ),
    );
  }

  void _onMonsterTap(Monster monster, UserMonster? userMonster) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MonsterDetailScreen(
          monster: monster,
          userMonster: userMonster,
        ),
      ),
    );
  }
}

/// 몬스터 그리드
class _MonsterGrid extends StatelessWidget {
  final String? attribute;
  final List<UserMonster> userMonsters;
  final void Function(Monster, UserMonster?) onMonsterTap;

  const _MonsterGrid({
    required this.attribute,
    required this.userMonsters,
    required this.onMonsterTap,
  });

  @override
  Widget build(BuildContext context) {
    // 전체 몬스터 필터링
    final monsters = attribute == null
        ? SampleMonsters.all
        : SampleMonsters.getByAttribute(attribute!);

    // 획득한 몬스터 ID 세트
    final ownedIds = userMonsters.map((m) => m.monsterId).toSet();

    // 획득순 정렬: 획득한 것 먼저, 그 다음 스테이지 순
    final sortedMonsters = [...monsters]..sort((a, b) {
      final aOwned = ownedIds.contains(a.id);
      final bOwned = ownedIds.contains(b.id);
      if (aOwned && !bOwned) return -1;
      if (!aOwned && bOwned) return 1;
      return a.stage.compareTo(b.stage);
    });

    // 통계
    final ownedCount = monsters.where((m) => ownedIds.contains(m.id)).length;
    final totalCount = monsters.length;

    return Column(
      children: [
        // 수집 현황
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Text(
                '수집 현황',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$ownedCount / $totalCount',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              // 진행률 바
              SizedBox(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: totalCount > 0 ? ownedCount / totalCount : 0,
                    backgroundColor: AppColors.surface,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 그리드
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: sortedMonsters.length,
            itemBuilder: (context, index) {
              final monster = sortedMonsters[index];
              final userMonster = userMonsters
                  .where((m) => m.monsterId == monster.id)
                  .firstOrNull;

              return MonsterCard(
                monster: monster,
                userMonster: userMonster,
                onTap: () => onMonsterTap(monster, userMonster),
              );
            },
          ),
        ),
      ],
    );
  }
}
