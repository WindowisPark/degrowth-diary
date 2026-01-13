import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/image_loader.dart';
import '../../../../domain/entities/monster.dart';
import '../../../../domain/entities/user_monster.dart';
import '../../../../providers/monster_catalog_provider.dart';
import '../../../../providers/user_monster_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../collection/collection_screen.dart';

/// 몬스터 서식지 - 홈 화면 메인 영역
class MonsterHabitat extends ConsumerWidget {
  const MonsterHabitat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myMonsters = ref.watch(myMonstersStreamProvider);
    final streakCount = ref.watch(streakCountProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A15),
            Color(0xFF12122A),
            Color(0xFF1A1A35),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 배경 파티클/분위기
            const _BackgroundEffects(),

            // 메인 콘텐츠
            myMonsters.when(
              data: (monsters) {
                if (monsters.isEmpty) {
                  return const _EmptyHabitat();
                }
                // 가장 많이 소환한 몬스터를 대표로
                final mainMonster = _getMainMonster(monsters);
                return _MonsterDisplay(
                  userMonster: mainMonster,
                  streakCount: streakCount,
                );
              },
              loading: () => const _LoadingHabitat(),
              error: (_, __) => const _EmptyHabitat(),
            ),
          ],
        ),
      ),
    );
  }

  UserMonster _getMainMonster(List<UserMonster> monsters) {
    if (monsters.isEmpty) {
      return UserMonster(
        monsterId: 'default',
        level: 1,
        exp: 0,
        summonCount: 0,
        unlockedAt: DateTime.now(),
      );
    }
    // summonCount 기준 정렬
    final sorted = [...monsters]..sort((a, b) => b.summonCount.compareTo(a.summonCount));
    return sorted.first;
  }
}

/// 배경 효과
class _BackgroundEffects extends StatelessWidget {
  const _BackgroundEffects();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _ParticlePainter(),
      ),
    );
  }
}

/// 파티클 페인터 (간단한 점들)
class _ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // 랜덤 위치에 작은 원들 (고정 위치로 일단 구현)
    final particles = [
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.85, size.height * 0.15),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.7, size.height * 0.8),
    ];

    for (final p in particles) {
      canvas.drawCircle(p, 2, paint);
    }

    // 바닥 그라데이션 (안개 느낌)
    final fogPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.primary.withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3));

    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
      fogPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 몬스터 표시
class _MonsterDisplay extends ConsumerWidget {
  final UserMonster userMonster;
  final int streakCount;

  const _MonsterDisplay({
    required this.userMonster,
    required this.streakCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monsterCatalog = ref.watch(monsterCatalogProvider);

    return monsterCatalog.when(
      data: (monsters) {
        final monster = monsters[userMonster.monsterId];
        return _MonsterContent(
          monster: monster,
          userMonster: userMonster,
          streakCount: streakCount,
        );
      },
      loading: () => const _LoadingHabitat(),
      error: (_, __) => _MonsterContent(
        monster: null,
        userMonster: userMonster,
        streakCount: streakCount,
      ),
    );
  }
}

/// 몬스터 콘텐츠
class _MonsterContent extends StatefulWidget {
  final Monster? monster;
  final UserMonster userMonster;
  final int streakCount;

  const _MonsterContent({
    required this.monster,
    required this.userMonster,
    required this.streakCount,
  });

  @override
  State<_MonsterContent> createState() => _MonsterContentState();
}

class _MonsterContentState extends State<_MonsterContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  final List<String> _quotes = [
    '주인님 덕분에 매일 건강해요!',
    '오늘도 솔직하시네요 ㅋㅋ',
    '완벽한 사람은 없죠~',
    '인정하는 게 첫걸음이에요',
    '내일은 또 다른 날이에요',
    '우리 함께 가볼까요?',
    '주인님은 정직하시군요',
    '괜찮아요, 다들 그래요!',
  ];

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monster = widget.monster;
    final userMonster = widget.userMonster;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // 몬스터 캐릭터
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CollectionScreen(),
                  ),
                );
              },
              child: AnimatedBuilder(
                animation: _breathAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_breathAnimation.value),
                    child: child,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 몬스터 아바타
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: monster != null
                            ? ImageLoader.loadMonsterImageById(
                                monster!.id,
                                imageUrl: monster!.imageUrl.isNotEmpty ? monster!.imageUrl : null,
                                width: 80,
                                height: 80,
                                fallback: _defaultMonsterIcon(),
                              )
                            : _defaultMonsterIcon(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 몬스터 이름
                    Text(
                      monster?.name ?? '???',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 말풍선
                    _SpeechBubble(
                      text: _quotes[DateTime.now().second % _quotes.length],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(flex: 1),

          // 하단 인포 바
          _BottomInfoBar(
            streakCount: widget.streakCount,
            level: userMonster.level,
            exp: userMonster.exp,
            maxExp: userMonster.expToNextLevel,
          ),
        ],
      ),
    );
  }

  Widget _defaultMonsterIcon() {
    return const Icon(
      Icons.pest_control,
      size: 60,
      color: AppColors.primary,
    );
  }
}

/// 말풍선
class _SpeechBubble extends StatelessWidget {
  final String text;

  const _SpeechBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Text(
        '"$text"',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

/// 하단 인포 바 (스트릭 + 레벨)
class _BottomInfoBar extends StatelessWidget {
  final int streakCount;
  final int level;
  final int exp;
  final int maxExp;

  const _BottomInfoBar({
    required this.streakCount,
    required this.level,
    required this.exp,
    required this.maxExp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 스트릭 뱃지
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '$streakCount일',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // 레벨 + EXP 바
        Row(
          children: [
            Text(
              'Lv.$level',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: maxExp > 0 ? exp / maxExp : 0,
                  backgroundColor: AppColors.surface,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  minHeight: 6,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 빈 서식지 (첫 기록 전)
class _EmptyHabitat extends StatelessWidget {
  const _EmptyHabitat();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 알 아이콘
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(
                color: AppColors.border,
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                '🥚',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '첫 기록을 하면',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '뭔가 태어날지도...?',
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// 로딩 상태
class _LoadingHabitat extends StatelessWidget {
  const _LoadingHabitat();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 2,
      ),
    );
  }
}
