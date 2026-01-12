import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import 'widgets/nickname_edit_dialog.dart';
import 'widgets/settings_item.dart';
import 'widgets/settings_section.dart';
import 'widgets/time_picker_dialog.dart';

/// 설정 화면
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: userAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Text(
            '오류가 발생했습니다',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text(
                '유저 정보를 불러올 수 없습니다',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView(
            children: [
              // 프로필 섹션
              SettingsSection(
                title: '프로필',
                children: [
                  SettingsItem(
                    icon: Icons.person_outline,
                    title: '닉네임',
                    subtitle: user.nickname,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => _showNicknameEditDialog(context, ref, user.nickname),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  SettingsItem(
                    icon: Icons.calendar_today_outlined,
                    title: '가입일',
                    subtitle: DateFormat('yyyy.MM.dd').format(user.createdAt),
                  ),
                ],
              ),

              // 알림 설정 섹션
              SettingsSection(
                title: '알림 설정',
                children: [
                  SettingsItem(
                    icon: Icons.notifications_outlined,
                    title: '푸시 알림',
                    trailing: Switch(
                      value: user.settings.pushEnabled,
                      onChanged: (value) {
                        final newSettings = user.settings.copyWith(pushEnabled: value);
                        ref.read(userNotifierProvider.notifier).updateSettings(newSettings);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ),
                  if (user.settings.pushEnabled) ...[
                    const Divider(height: 1, color: AppColors.border),
                    SettingsItem(
                      icon: Icons.access_time,
                      title: '알림 시간',
                      subtitle: user.settings.pushTime,
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                      onTap: () => _showTimePickerDialog(
                        context,
                        ref,
                        user.settings,
                      ),
                    ),
                  ],
                ],
              ),

              // 테마 설정 섹션
              SettingsSection(
                title: '테마 설정',
                children: [
                  SettingsItem(
                    icon: Icons.dark_mode_outlined,
                    title: '다크 모드',
                    trailing: Switch(
                      value: user.settings.darkMode,
                      onChanged: (value) {
                        final newSettings = user.settings.copyWith(darkMode: value);
                        ref.read(userNotifierProvider.notifier).updateSettings(newSettings);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ),
                ],
              ),

              // 업적 섹션
              SettingsSection(
                title: '게임',
                children: [
                  SettingsItem(
                    icon: Icons.emoji_events_outlined,
                    title: '업적',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () {
                      context.push(AppRoutes.achievements);
                    },
                  ),
                ],
              ),

              // 계정 관리 섹션
              SettingsSection(
                title: '계정 관리',
                children: [
                  SettingsItem(
                    icon: Icons.logout,
                    title: '로그아웃',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => _showSignOutDialog(context, ref),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  SettingsItem(
                    icon: Icons.delete_outline,
                    title: '회원탈퇴',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.error,
                    ),
                    onTap: () => _showDeleteAccountDialog(context, ref),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  /// 닉네임 수정 다이얼로그
  Future<void> _showNicknameEditDialog(
    BuildContext context,
    WidgetRef ref,
    String currentNickname,
  ) async {
    final newNickname = await showDialog<String>(
      context: context,
      builder: (context) => NicknameEditDialog(currentNickname: currentNickname),
    );

    if (newNickname != null && newNickname != currentNickname) {
      await ref.read(userNotifierProvider.notifier).updateNickname(newNickname);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('닉네임이 변경되었습니다'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  /// 시간 선택 다이얼로그
  Future<void> _showTimePickerDialog(
    BuildContext context,
    WidgetRef ref,
    settings,
  ) async {
    final newTime = await showTimePickerDialog(context, settings.pushTime);

    if (newTime != null && newTime != settings.pushTime) {
      final newSettings = settings.copyWith(pushTime: newTime);
      await ref.read(userNotifierProvider.notifier).updateSettings(newSettings);
    }
  }

  /// 로그아웃 확인 다이얼로그
  Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          '로그아웃',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          '정말 로그아웃하시겠습니까?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('로그아웃', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }

  /// 회원탈퇴 확인 다이얼로그
  Future<void> _showDeleteAccountDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          '회원탈퇴',
          style: TextStyle(color: AppColors.error),
        ),
        content: const Text(
          '정말 탈퇴하시겠습니까?\n\n모든 데이터가 삭제되며 복구할 수 없습니다.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('탈퇴', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).deleteAccount();
    }
  }
}
