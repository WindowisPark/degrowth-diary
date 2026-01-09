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
