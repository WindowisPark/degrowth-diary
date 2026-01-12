import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/user.dart';
import 'repository_providers.dart';

/// 현재 인증 상태 스트림
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges;
});

/// 현재 로그인된 유저
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

/// 로그인 여부
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

/// Auth Notifier
final authNotifierProvider = NotifierProvider<AuthNotifier, AsyncValue<User?>>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AsyncValue<User?>> {
  @override
  AsyncValue<User?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);

      // 1. Firebase Auth 로그인
      final user = await authRepo.signInWithGoogle();

      // 2. Firestore에 유저 문서 확인/생성
      final existingUser = await userRepo.getUser(user.id);
      if (existingUser == null) {
        print('[Auth] Creating new user document in Firestore...');
        await userRepo.createUser(user);
        print('[Auth] User document created');
      } else {
        print('[Auth] User document already exists');
      }

      return user;
    });
  }

  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);

      // 1. Firebase Auth 로그인
      final user = await authRepo.signInWithApple();

      // 2. Firestore에 유저 문서 확인/생성
      final existingUser = await userRepo.getUser(user.id);
      if (existingUser == null) {
        print('[Auth] Creating new user document in Firestore...');
        await userRepo.createUser(user);
        print('[Auth] User document created');
      } else {
        print('[Auth] User document already exists');
      }

      return user;
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
      return null;
    });
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).deleteAccount();
      return null;
    });
  }
}
