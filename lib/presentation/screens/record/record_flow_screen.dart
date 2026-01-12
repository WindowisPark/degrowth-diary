import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_data.dart';
import '../../../providers/record_provider.dart';
import 'widgets/quick_select_step.dart';
import 'widgets/severity_step.dart';
import 'widgets/record_complete_dialog.dart';
import 'widgets/monster_unlock_dialog.dart';

/// 기록 플로우 화면 - 2단계 (소분류 선택 → 심각도)
class RecordFlowScreen extends ConsumerStatefulWidget {
  const RecordFlowScreen({super.key});

  @override
  ConsumerState<RecordFlowScreen> createState() => _RecordFlowScreenState();
}

class _RecordFlowScreenState extends ConsumerState<RecordFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // 선택된 값들
  CategoryData? _selectedCategory;
  SubCategoryData? _selectedSubCategory;
  int _severity = 3;
  String? _memo;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onSubCategorySelected(CategoryData category, SubCategoryData subCategory) {
    setState(() {
      _selectedCategory = category;
      _selectedSubCategory = subCategory;
    });
    _nextStep();
  }

  Future<void> _onRecordSubmit() async {
    if (_selectedCategory == null || _selectedSubCategory == null) return;

    // 기록 생성 + 몬스터 획득 체크
    final result = await ref.read(recordNotifierProvider.notifier).createRecord(
      categoryKey: _selectedCategory!.key,
      subCategoryKey: _selectedSubCategory!.key,
      severity: _severity,
      memo: _memo,
    );

    if (!mounted) return;

    if (result != null) {
      // 몬스터 획득 시 - 화려한 연출
      if (result.unlockedMonster != null) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => MonsterUnlockDialog(
            monster: result.unlockedMonster!,
            onClose: () {
              Navigator.of(context).pop(); // 몬스터 다이얼로그 닫기
              Navigator.of(context).pop(); // 기록 화면 닫기
            },
          ),
        );
      } else {
        // 일반 완료 다이얼로그
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => RecordCompleteDialog(
            category: _selectedCategory!,
            subCategory: _selectedSubCategory!,
            severity: _severity,
            onClose: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              Navigator.of(context).pop(); // 기록 화면 닫기
            },
          ),
        );
      }
    } else {
      // 실패
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기록 저장에 실패했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
        title: _StepIndicator(currentStep: _currentStep, totalSteps: 2),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Step 1: 빠른 선택 (카테고리 탭 + 최근 + 소분류)
          QuickSelectStep(
            onSelected: _onSubCategorySelected,
          ),

          // Step 2: 심각도 + 메모
          SeverityStep(
            category: _selectedCategory,
            subCategory: _selectedSubCategory,
            initialSeverity: _severity,
            onSeverityChanged: (value) => setState(() => _severity = value),
            onMemoChanged: (value) => _memo = value,
            onSubmit: _onRecordSubmit,
          ),
        ],
      ),
    );
  }
}

/// 스텝 인디케이터
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        final isCurrent = index == currentStep;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isCurrent ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
