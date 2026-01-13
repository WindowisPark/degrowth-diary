import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firebase/firebase_achievement_repository.dart';
import '../data/firebase/firebase_auth_repository.dart';
import '../data/firebase/firebase_monster_catalog_repository.dart';
import '../data/firebase/firebase_record_repository.dart';
import '../data/firebase/firebase_user_monster_repository.dart';
import '../data/firebase/firebase_user_repository.dart';
import '../data/local/local_monster_catalog_repository.dart';
import '../domain/repositories/i_achievement_repository.dart';
import '../domain/repositories/i_auth_repository.dart';
import '../domain/repositories/i_monster_catalog_repository.dart';
import '../domain/repositories/i_record_repository.dart';
import '../domain/repositories/i_user_monster_repository.dart';
import '../domain/repositories/i_user_repository.dart';

/// Firebase 인스턴스
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Auth Repository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return FirebaseAuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(firestoreProvider),
  );
});

/// Record Repository
final recordRepositoryProvider = Provider<IRecordRepository>((ref) {
  return FirebaseRecordRepository(
    ref.watch(firestoreProvider),
    ref.watch(authRepositoryProvider),
  );
});

/// Monster Catalog Repository (글로벌 도감)
/// MVP: Local SampleMonsters 사용
final monsterCatalogRepositoryProvider = Provider<IMonsterCatalogRepository>((ref) {
  return LocalMonsterCatalogRepository();
  // TODO: 나중에 Firebase로 마이그레이션
  // return FirebaseMonsterCatalogRepository(ref.watch(firestoreProvider));
});

/// User Monster Repository (유저 소유)
final userMonsterRepositoryProvider = Provider<IUserMonsterRepository>((ref) {
  return FirebaseUserMonsterRepository(
    ref.watch(firestoreProvider),
    ref.watch(authRepositoryProvider),
  );
});

/// User Repository
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return FirebaseUserRepository(ref.watch(firestoreProvider));
});

/// Achievement Repository
final achievementRepositoryProvider = Provider<IAchievementRepository>((ref) {
  return FirebaseAchievementRepository(ref.watch(firestoreProvider));
});
