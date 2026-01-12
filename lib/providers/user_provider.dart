import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/user.dart';
import 'auth_provider.dart';
import 'repository_providers.dart';

/// 현재 유저 프로필 스트림
final userProfileStreamProvider = StreamProvider<User?>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return Stream.value(null);

  final userRepo = ref.watch(userRepositoryProvider);
  return userRepo.watchUser(currentUser.id);
});

/// 현재 유저 프로필 (Future)
final userProfileProvider = FutureProvider<User?>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return null;

  final userRepo = ref.watch(userRepositoryProvider);
  return userRepo.getUser(currentUser.id);
});

/// 스트릭 카운트
final streakCountProvider = Provider<int>((ref) {
  final profile = ref.watch(userProfileStreamProvider).valueOrNull;
  return profile?.streakCount ?? 0;
});

/// 다크모드 설정
final isDarkModeProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileStreamProvider).valueOrNull;
  return profile?.settings.darkMode ?? false;
});

/// 오늘 체크인 완료 여부
final isTodayCheckedInProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileStreamProvider).valueOrNull;
  if (profile == null) return false;

  final lastCheckIn = profile.lastRecordDate;
  if (lastCheckIn == null) return false;

  // 오늘 날짜와 비교
  final today = DateTime.now();
  final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

  return lastCheckIn == todayStr;
});

/// 유저 Notifier (닉네임, 설정 업데이트)
class UserNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  /// 닉네임 업데이트
  Future<void> updateNickname(String nickname) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception('로그인이 필요합니다');
      }

      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.updateNickname(currentUser.id, nickname);
    });
  }

  /// 설정 업데이트
  Future<void> updateSettings(UserSettings settings) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception('로그인이 필요합니다');
      }

      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.updateSettings(currentUser.id, settings);
    });
  }

  /// 스트릭 업데이트 (기록 생성 시 호출)
  Future<void> updateStreakOnRecord(String todayRecordDate) async {
    await _updateCheckIn(todayRecordDate);
  }

  /// 데일리 체크인 (기록 없이도 가능)
  Future<void> dailyCheckIn(String todayDate) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _updateCheckIn(todayDate);
    });
  }

  /// 체크인 공통 로직
  Future<void> _updateCheckIn(String todayDate) async {
    final currentUser = ref.read(userProfileStreamProvider).valueOrNull;
    if (currentUser == null) return;

    final newStreak = _calculateNewStreak(
      currentUser.lastRecordDate,
      todayDate,
      currentUser.streakCount,
    );

    // 스트릭이 변경되었을 때만 업데이트
    if (newStreak != currentUser.streakCount ||
        currentUser.lastRecordDate != todayDate) {
      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.updateStreak(
        userId: currentUser.id,
        streakCount: newStreak,
        lastRecordDate: todayDate,
      );
    }
  }

  /// 스트릭 계산 로직
  int _calculateNewStreak(
    String? lastRecordDate,
    String today,
    int currentStreak,
  ) {
    if (lastRecordDate == null) {
      // 첫 기록
      return 1;
    }

    if (lastRecordDate == today) {
      // 오늘 이미 기록함 (스트릭 유지)
      return currentStreak;
    }

    try {
      // 날짜 파싱 (YYYY-MM-DD 형식)
      final lastDate = DateTime.parse(lastRecordDate);
      final todayDate = DateTime.parse(today);
      final difference = todayDate.difference(lastDate).inDays;

      if (difference == 1) {
        // 어제 기록함 (연속)
        return currentStreak + 1;
      } else {
        // 하루 이상 빠짐 (리셋)
        return 1;
      }
    } catch (e) {
      // 날짜 파싱 오류 시 리셋
      return 1;
    }
  }
}

final userNotifierProvider = NotifierProvider<UserNotifier, AsyncValue<void>>(
  UserNotifier.new,
);
