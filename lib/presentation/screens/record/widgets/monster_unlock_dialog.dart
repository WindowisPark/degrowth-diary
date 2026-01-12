import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/category_data.dart';
import '../../../../core/utils/image_loader.dart';
import '../../../../domain/entities/monster.dart';

/// 몬스터 획득 연출 다이얼로그 (가챠 스타일)
class MonsterUnlockDialog extends StatefulWidget {
  final Monster monster;
  final VoidCallback onClose;

  const MonsterUnlockDialog({
    super.key,
    required this.monster,
    required this.onClose,
  });

  @override
  State<MonsterUnlockDialog> createState() => _MonsterUnlockDialogState();
}

class _MonsterUnlockDialogState extends State<MonsterUnlockDialog>
    with TickerProviderStateMixin {
  // 애니메이션 컨트롤러들
  late AnimationController _buildupController;
  late AnimationController _revealController;
  late AnimationController _glowController;
  late AnimationController _floatController;
  late ConfettiController _confettiController;

  // 애니메이션들
  late Animation<double> _buildupScale;
  late Animation<double> _buildupOpacity;
  late Animation<double> _revealScale;
  late Animation<double> _revealOpacity;
  late Animation<double> _glowAnimation;
  late Animation<double> _floatAnimation;

  // 상태
  bool _showMonster = false;
  bool _showInfo = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // 1. 빌드업 (빛이 모이는 효과)
    _buildupController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _buildupScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buildupController, curve: Curves.easeOut),
    );
    _buildupOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buildupController, curve: Curves.easeIn),
    );

    // 2. 리빌 (몬스터 등장)
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _revealScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.elasticOut),
    );
    _revealOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // 3. 글로우 (지속적인 빛남)
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // 4. 플로팅 (위아래 움직임)
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // 5. 컨페티
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _startSequence() async {
    // Phase 1: 빌드업
    await _buildupController.forward();

    // Phase 2: 플래시 + 몬스터 등장
    setState(() => _showMonster = true);
    _confettiController.play();
    await _revealController.forward();

    // Phase 3: 정보 표시
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _showInfo = true);
  }

  @override
  void dispose() {
    _buildupController.dispose();
    _revealController.dispose();
    _glowController.dispose();
    _floatController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Color get _rarityColor {
    switch (widget.monster.rarity) {
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

  Color get _categoryColor {
    final category = Categories.getByKey(widget.monster.attribute);
    return category?.color ?? AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // 배경 (탭하면 닫기)
          GestureDetector(
            onTap: _showInfo ? widget.onClose : null,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withAlpha(220),
            ),
          ),

          // 빌드업 이펙트 (빛 집중)
          if (!_showMonster)
            Center(
              child: AnimatedBuilder(
                animation: _buildupController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _buildupOpacity.value,
                    child: Transform.scale(
                      scale: _buildupScale.value,
                      child: _BuildupEffect(color: _rarityColor),
                    ),
                  );
                },
              ),
            ),

          // 컨페티
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 30,
              minBlastForce: 10,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.2,
              shouldLoop: false,
              colors: [
                _rarityColor,
                _categoryColor,
                Colors.white,
                Colors.amber,
              ],
            ),
          ),

          // 몬스터 + 정보
          if (_showMonster)
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _revealController,
                  _glowController,
                  _floatController,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: Opacity(
                      opacity: _revealOpacity.value,
                      child: Transform.scale(
                        scale: _revealScale.value,
                        child: _MonsterReveal(
                          monster: widget.monster,
                          rarityColor: _rarityColor,
                          categoryColor: _categoryColor,
                          glowIntensity: _glowAnimation.value,
                          showInfo: _showInfo,
                          onClose: widget.onClose,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // 탭 안내
          if (_showInfo)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _showInfo ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: const Text(
                  '탭하여 계속',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 빌드업 이펙트 (빛이 모이는 효과)
class _BuildupEffect extends StatelessWidget {
  final Color color;

  const _BuildupEffect({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 외부 링
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withAlpha(100), width: 2),
            ),
          ),
          // 중간 링
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withAlpha(150), width: 3),
            ),
          ),
          // 중심 글로우
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withAlpha(100),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(150),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // 파티클들 (간단한 점)
          ..._buildParticles(),
        ],
      ),
    );
  }

  List<Widget> _buildParticles() {
    final random = Random(42); // 고정 시드
    return List.generate(12, (i) {
      final angle = (i / 12) * 2 * pi;
      final distance = 60 + random.nextDouble() * 30;
      return Positioned(
        left: 100 + cos(angle) * distance - 4,
        top: 100 + sin(angle) * distance - 4,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(200),
          ),
        ),
      );
    });
  }
}

/// 몬스터 리빌 (등장 + 정보)
class _MonsterReveal extends StatelessWidget {
  final Monster monster;
  final Color rarityColor;
  final Color categoryColor;
  final double glowIntensity;
  final bool showInfo;
  final VoidCallback onClose;

  const _MonsterReveal({
    required this.monster,
    required this.rarityColor,
    required this.categoryColor,
    required this.glowIntensity,
    required this.showInfo,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 레어도 텍스트
        AnimatedOpacity(
          opacity: showInfo ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: _RarityBanner(rarity: monster.rarity, color: rarityColor),
        ),

        const SizedBox(height: 20),

        // 몬스터 아바타 (글로우 효과)
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: categoryColor.withAlpha(40),
            border: Border.all(
              color: rarityColor.withAlpha((150 * glowIntensity).toInt()),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: rarityColor.withAlpha((100 * glowIntensity).toInt()),
                blurRadius: 40 * glowIntensity,
                spreadRadius: 10 * glowIntensity,
              ),
              BoxShadow(
                color: categoryColor.withAlpha((80 * glowIntensity).toInt()),
                blurRadius: 60 * glowIntensity,
                spreadRadius: 20 * glowIntensity,
              ),
            ],
          ),
          child: Center(
            child: ImageLoader.loadMonsterImage(
              monster.imageUrl,
              width: 100,
              height: 100,
              fallback: _defaultIcon(),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // 몬스터 이름
        AnimatedOpacity(
          opacity: showInfo ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            monster.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: rarityColor.withAlpha(150),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 설명
        AnimatedOpacity(
          opacity: showInfo ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              '"${monster.description}"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _defaultIcon() {
    return Icon(
      Icons.pest_control,
      color: categoryColor,
      size: 80,
    );
  }
}

/// 레어도 배너
class _RarityBanner extends StatelessWidget {
  final String rarity;
  final Color color;

  const _RarityBanner({required this.rarity, required this.color});

  @override
  Widget build(BuildContext context) {
    final label = _getLabel();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withAlpha(0),
            color.withAlpha(80),
            color.withAlpha(80),
            color.withAlpha(0),
          ],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
      ),
    );
  }

  String _getLabel() {
    switch (rarity) {
      case 'common':
        return 'COMMON';
      case 'rare':
        return '★ RARE ★';
      case 'epic':
        return '★★ EPIC ★★';
      case 'legendary':
        return '★★★ LEGENDARY ★★★';
      default:
        return 'COMMON';
    }
  }
}
