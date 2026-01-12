import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// 시간 선택 다이얼로그
Future<String?> showTimePickerDialog(
  BuildContext context,
  String currentTime,
) async {
  // "HH:mm" 형식의 문자열을 TimeOfDay로 파싱
  final parts = currentTime.split(':');
  final initialTime = TimeOfDay(
    hour: int.parse(parts[0]),
    minute: int.parse(parts[1]),
  );

  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: AppColors.textOnPrimary,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
          dialogBackgroundColor: AppColors.surface,
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    // TimeOfDay를 "HH:mm" 형식의 문자열로 변환
    final hour = picked.hour.toString().padLeft(2, '0');
    final minute = picked.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  return null;
}
