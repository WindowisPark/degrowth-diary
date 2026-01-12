import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/category_data.dart';

/// Step 3: 심각도 + 메모 입력
class SeverityStep extends StatefulWidget {
  final CategoryData? category;
  final SubCategoryData? subCategory;
  final int initialSeverity;
  final void Function(int) onSeverityChanged;
  final void Function(String?) onMemoChanged;
  final VoidCallback onSubmit;

  const SeverityStep({
    super.key,
    required this.category,
    required this.subCategory,
    required this.initialSeverity,
    required this.onSeverityChanged,
    required this.onMemoChanged,
    required this.onSubmit,
  });

  @override
  State<SeverityStep> createState() => _SeverityStepState();
}

class _SeverityStepState extends State<SeverityStep> {
  late int _severity;
  final _memoController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _severity = widget.initialSeverity;
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    widget.onMemoChanged(_memoController.text.isEmpty ? null : _memoController.text);
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.category == null || widget.subCategory == null) {
      return const Center(child: Text('이전 단계를 완료해주세요'));
    }

    final color = widget.category!.color;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 선택 정보 표시
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withAlpha(60),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    widget.subCategory!.emoji ?? '',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subCategory!.label,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.category!.label,
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 심각도 섹션
            const Text(
              '얼마나 망했어?',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // 심각도 슬라이더
            _SeveritySlider(
              value: _severity,
              onChanged: (value) {
                setState(() => _severity = value);
                widget.onSeverityChanged(value);
              },
            ),

            const SizedBox(height: 48),

            // 메모 섹션
            const Text(
              '한마디 (선택)',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _memoController,
              maxLines: 3,
              maxLength: 100,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: '오늘의 변명을 적어보세요...',
                hintStyle: TextStyle(color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: color, width: 2),
                ),
                counterStyle: TextStyle(color: AppColors.textHint),
              ),
            ),

            const SizedBox(height: 40),

            // 기록하기 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: color.withAlpha(100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        '기록하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// 심각도 슬라이더
class _SeveritySlider extends StatelessWidget {
  final int value;
  final void Function(int) onChanged;

  const _SeveritySlider({
    required this.value,
    required this.onChanged,
  });

  static const _labels = ['살짝', '조금', '보통', '많이', '극심'];
  static const _colors = [
    AppColors.severity1,
    AppColors.severity2,
    AppColors.severity3,
    AppColors.severity4,
    AppColors.severity5,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 버튼들
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final level = index + 1;
            final isSelected = level == value;
            final color = _colors[index];

            return GestureDetector(
              onTap: () => onChanged(level),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 56 : 48,
                height: isSelected ? 56 : 48,
                decoration: BoxDecoration(
                  color: isSelected ? color : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? color : AppColors.border,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withAlpha(100),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$level',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: isSelected ? 20 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // 라벨
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final isSelected = (index + 1) == value;
            return SizedBox(
              width: 56,
              child: Text(
                _labels[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? _colors[index] : AppColors.textHint,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
