import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/screens/auth/auth_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../providers/auth_provider.dart';

/// 라우트 경로 상수
abstract class AppRoutes {
  static const splash = '/splash';
  static const auth = '/auth';
  static const home = '/';
  static const record = '/record';
  static const collection = '/collection';
  static const mypage = '/mypage';
}

/// Auth 상태 변경 감지용 Listenable
class _AuthNotifierListenable extends ChangeNotifier {
  _AuthNotifierListenable(Ref ref) {
    ref.listen(authStateProvider, (_, __) {
      notifyListeners();
    });
  }
}

/// GoRouter Provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final refreshListenable = _AuthNotifierListenable(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final isLoggedIn = authState.valueOrNull != null;
      final isOnSplash = state.matchedLocation == AppRoutes.splash;
      final isOnAuth = state.matchedLocation == AppRoutes.auth;

      // 로딩 중이면 스플래시
      if (isLoading) {
        return isOnSplash ? null : AppRoutes.splash;
      }

      // 로그인 안 됐으면 auth로
      if (!isLoggedIn) {
        return isOnAuth ? null : AppRoutes.auth;
      }

      // 로그인 됐는데 splash나 auth면 home으로
      if (isOnSplash || isOnAuth) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      // TODO: 추가 라우트
      // GoRoute(
      //   path: AppRoutes.record,
      //   builder: (context, state) => const RecordScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.collection,
      //   builder: (context, state) => const CollectionScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.mypage,
      //   builder: (context, state) => const MypageScreen(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
