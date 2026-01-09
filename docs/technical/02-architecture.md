# 아키텍처 설계

## 기본 방침

| 항목 | 결정 |
| --- | --- |
| 초기 | Firebase BaaS로 MVP |
| 구조 | 인터페이스 추상화 (교체 용이) |
| 향후 | FastAPI 마이그레이션 가능 |

---

## 레이어 구조

```
┌─────────────────────────────────────┐
│         Presentation (UI)           │  ← 화면, 위젯
├─────────────────────────────────────┤
│         Providers (State)           │  ← Riverpod 상태관리
├─────────────────────────────────────┤
│         Domain (Interface)          │  ← 추상화 레이어
├─────────────────────────────────────┤
│         Data (Implementation)       │  ← Firebase 구현체
├─────────────────────────────────────┤
│         Firebase / External         │  ← 외부 서비스
└─────────────────────────────────────┘
```

---

## 폴더 구조

```
lib/
├── main.dart
│
├── app/                          # 앱 설정
│   ├── app.dart                   # MaterialApp
│   ├── routes.dart                # 라우팅
│   └── theme.dart                 # 테마
│
├── core/                         # 공통 유틸
│   ├── constants/
│   │   ├── colors.dart
│   │   ├── strings.dart
│   │   └── categories.dart        # 카테고리 상수
│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── validators.dart
│   ├── errors/                    # 에러 처리
│   │   └── failures.dart
│   └── extensions/
│
├── domain/                       # 추상화 레이어
│   ├── entities/                  # 순수 데이터 클래스
│   │   ├── user.dart
│   │   ├── record.dart
│   │   ├── monster.dart
│   │   └── user_monster.dart
│   │
│   └── repositories/             # 인터페이스
│       ├── i_auth_repository.dart
│       ├── i_record_repository.dart
│       ├── i_monster_catalog_repository.dart  # 글로벌 몬스터 도감
│       ├── i_user_monster_repository.dart     # 유저 소유 몬스터
│       └── i_user_repository.dart
│
├── data/                         # 구현체
│   ├── firebase/                  # Firebase 구현
│   │   ├── firebase_auth_repository.dart
│   │   ├── firebase_record_repository.dart
│   │   ├── firebase_monster_catalog_repository.dart
│   │   ├── firebase_user_monster_repository.dart
│   │   └── firebase_user_repository.dart
│   │
│   ├── local/                     # 로컬 캐시 (Hive)
│   │   ├── local_monster_catalog_repository.dart
│   │   └── local_record_repository.dart
│   │
│   ├── api/                       # REST API 구현 (후순위)
│   │   └── (... 나중에 추가)
│   │
│   ├── models/                    # DTO (Firebase 변환용)
│   │   ├── record_model.dart
│   │   ├── monster_model.dart
│   │   ├── user_monster_model.dart
│   │   └── user_model.dart
│   │
│   └── services/                  # 외부 서비스
│       ├── firebase_service.dart
│       └── notification_service.dart
│
├── providers/                    # Riverpod
│   ├── repository_providers.dart  # DI 설정
│   ├── auth_provider.dart
│   ├── record_provider.dart
│   ├── monster_catalog_provider.dart
│   ├── user_monster_provider.dart
│   └── user_provider.dart
│
├── presentation/                 # UI
│   ├── screens/
│   │   ├── splash/
│   │   ├── onboarding/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── record/
│   │   ├── collection/
│   │   └── mypage/
│   │
│   ├── widgets/                   # 공통 위젯
│   │   ├── common_button.dart
│   │   ├── monster_card.dart
│   │   └── loading_indicator.dart
│   │
│   └── dialogs/                   # 팝업/다이얼로그
│       ├── monster_unlock_dialog.dart
│       └── exp_gained_sheet.dart
│
└── gen/                          # 자동생성
    └── assets.gen.dart
```

---

## Entity vs Model

| 구분 | Entity | Model |
| --- | --- | --- |
| 위치 | domain/entities/ | data/models/ |
| 역할 | 순수 데이터 | Firebase 변환 |
| 의존성 | 없음 | Firebase 타입 (Timestamp 등) |
| 예시 | `Record` | `RecordModel` (toJson/fromJson) |

### Entity 정의

```dart
// domain/entities/record.dart
class Record {
  final String id;
  final String categoryKey;       // "food", "sleep", ...
  final String subCategoryKey;    // "late_night", "binge", ...
  final int severity;             // 1~5
  final String? memo;
  final String recordDate;        // "2026-01-09" (집계용)
  final DateTime createdAt;
  final bool hasMonster;
  final String? monsterId;
}

// domain/entities/monster.dart
class Monster {
  final String id;
  final String name;
  final String attribute;         // "gluttony", "sloth", ...
  final String rarity;            // "common", "rare", "epic", "legendary"
  final String description;
  final String imageUrl;
  final UnlockCondition unlockCondition;
  final String? evolutionTo;      // 단방향만
  final int stage;                // 1, 2, 3
}

class UnlockCondition {
  final String categoryKey;
  final int count;
}

// domain/entities/user_monster.dart
class UserMonster {
  final String monsterId;
  final int level;
  final int exp;
  final int summonCount;          // 누적 소환 횟수
  final DateTime unlockedAt;
}

// domain/entities/user.dart
class User {
  final String id;
  final String nickname;
  final DateTime createdAt;
  final String timezone;          // "Asia/Seoul"
  final int streakCount;          // 읽기 전용 (서버 관리)
  final String? lastRecordDate;   // 읽기 전용 (서버 관리)
  final UserSettings settings;
}

class UserSettings {
  final bool pushEnabled;
  final String pushTime;          // "21:00"
  final bool darkMode;
}
```

### Model 변환 예시

```dart
// data/models/record_model.dart (Firebase용)
class RecordModel {
  // Entity → Model
  factory RecordModel.fromEntity(Record record) { ... }

  // Firestore → Model
  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      // ... 다른 필드들
    );
  }

  // Model → Entity
  Record toEntity() { ... }

  // Model → Firestore
  Map<String, dynamic> toJson() { ... }
}
```

---

## 인터페이스 정의

### IRecordRepository

```dart
abstract class IRecordRepository {
  /// 오늘 기록 조회
  Future<List<Record>> getTodayRecords();

  /// 기간별 기록 조회
  Future<List<Record>> getRecordsByDateRange(
    DateTime start,
    DateTime end,
  );

  /// 기록 생성
  Future<String> createRecord(Record record);

  /// 기록 수정 (몬스터 연결 등)
  Future<void> updateRecord(String id, Map<String, dynamic> data);

  /// 기록 삭제
  Future<void> deleteRecord(String id);

  /// 오늘 기록 수 조회
  Future<int> getTodayRecordCount();

  /// 실시간 스트림 (Firebase만)
  Stream<List<Record>> watchTodayRecords();
}
```

### IMonsterCatalogRepository

글로벌 몬스터 도감 (monsters 컬렉션)

```dart
abstract class IMonsterCatalogRepository {
  /// 전체 몬스터 도감 조회
  Future<List<Monster>> getAll();

  /// 특정 몬스터 조회
  Future<Monster?> getById(String id);

  /// 카테고리별 몬스터 조회
  Future<List<Monster>> getByCategory(String categoryKey);

  /// 해금 조건 체크
  Future<Monster?> checkUnlockCondition({
    required String categoryKey,
    required int count,
  });
}
```

### IUserMonsterRepository

유저 소유 몬스터 (users/{id}/userMonsters 서브컬렉션)

```dart
abstract class IUserMonsterRepository {
  /// 유저가 보유한 몬스터 조회
  Future<List<UserMonster>> getMyMonsters();

  /// 특정 몬스터 보유 여부
  Future<UserMonster?> getById(String monsterId);

  /// 몬스터 해금
  Future<void> unlock(String monsterId);

  /// 경험치 추가
  Future<void> addExp(String monsterId, int exp);

  /// 소환 횟수 증가
  Future<void> incrementSummonCount(String monsterId);

  /// 실시간 스트림
  Stream<List<UserMonster>> watchMyMonsters();
}
```

### IAuthRepository

```dart
abstract class IAuthRepository {
  /// 현재 유저
  User? get currentUser;

  /// 인증 상태 스트림
  Stream<User?> get authStateChanges;

  /// Google 로그인
  Future<User> signInWithGoogle();

  /// Apple 로그인
  Future<User> signInWithApple();

  /// 로그아웃
  Future<void> signOut();

  /// 회원탈퇴
  Future<void> deleteAccount();
}
```

---

## Provider DI 설정

```dart
// providers/repository_providers.dart

// Auth
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return FirebaseAuthRepository(FirebaseAuth.instance);
});

// Record
final recordRepositoryProvider = Provider<IRecordRepository>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return FirebaseRecordRepository(
    FirebaseFirestore.instance,
    auth,
  );
});

// Monster Catalog (글로벌 도감)
final monsterCatalogRepositoryProvider = Provider<IMonsterCatalogRepository>((ref) {
  return FirebaseMonsterCatalogRepository(
    FirebaseFirestore.instance,
  );
});

// User Monster (유저 소유)
final userMonsterRepositoryProvider = Provider<IUserMonsterRepository>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return FirebaseUserMonsterRepository(
    FirebaseFirestore.instance,
    auth,
  );
});

// 나중에 API로 교체 시:
// return ApiRecordRepository(ref.watch(dioProvider));
```

---

## 데이터 흐름

### 기록 저장 플로우

```
[UI] 기록 버튼 클릭
       ↓
[Provider] createRecord() 호출
       ↓
[IRecordRepository] 인터페이스
       ↓
[FirebaseRecordRepository] Firestore 저장
       ↓
[IMonsterRepository] 해금 조건 체크
       ↓
┌─────┴─────┐
↓           ↓
신규 몬스터   기존 몬스터
↓           ↓
풀스크린     바텀시트
```

---

## 교체 시 변경점

| 레이어 | Firebase → REST API |
| --- | --- |
| domain/entities | 변경 없음 ✅ |
| domain/repositories | 변경 없음 ✅ |
| data/firebase | 삭제 또는 유지 |
| data/api | 새로 구현 |
| providers | 한 줄 수정 |
| presentation | 변경 없음 ✅ |

---

## 주의사항

### Stream 처리

Firebase는 실시간 스트림 지원, REST API는 안 됨

```dart
abstract class IRecordRepository {
  // Firebase: Firestore 스트림
  // API: polling 또는 미지원
  Stream<List<Record>> watchTodayRecords();
}

// API 구현 시
class ApiRecordRepository implements IRecordRepository {
  @override
  Stream<List<Record>> watchTodayRecords() {
    // 옵션 1: polling
    return Stream.periodic(Duration(seconds: 30))
        .asyncMap((_) => getTodayRecords());

    // 옵션 2: 미지원
    throw UnimplementedError('실시간 스트림 미지원');
  }
}
```

### hasMonster 플래그

```dart
class Record {
  final bool hasMonster;      // ← 명시적 플래그
  final String? monsterId;
}
```

이유: Firestore에서 null 쿼리 이슈 방지

---

## Error Handling 전략

### Failure 클래스 정의

```dart
// core/errors/failures.dart
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = '네트워크 연결을 확인해주세요']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = '인증에 실패했습니다']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = '서버 오류가 발생했습니다']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = '로컬 데이터를 불러올 수 없습니다']);
}
```

### Repository 에러 처리

```dart
// Repository에서 try-catch로 Failure 변환
class FirebaseRecordRepository implements IRecordRepository {
  @override
  Future<List<Record>> getTodayRecords() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs.map((doc) => RecordModel.fromJson(doc.data()).toEntity()).toList();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? '서버 오류');
    } on SocketException {
      throw const NetworkFailure();
    }
  }
}
```

### Provider 에러 처리

```dart
// Riverpod AsyncValue 활용
final todayRecordsProvider = FutureProvider<List<Record>>((ref) async {
  final repo = ref.watch(recordRepositoryProvider);
  return repo.getTodayRecords();
});

// UI에서 사용
ref.watch(todayRecordsProvider).when(
  data: (records) => RecordList(records),
  loading: () => const LoadingIndicator(),
  error: (error, stack) => ErrorView(
    message: error is Failure ? error.message : '알 수 없는 오류',
    onRetry: () => ref.invalidate(todayRecordsProvider),
  ),
);
```

---

## Offline 전략

### 캐싱 범위

| 데이터 | 캐싱 여부 | 전략 |
| --- | --- | --- |
| 몬스터 도감 | ✅ 전체 캐싱 | 앱 시작 시 동기화, 거의 변경 없음 |
| 오늘 기록 | ✅ 캐싱 | Firestore offline + Hive 백업 |
| 유저 몬스터 | ✅ 캐싱 | Firestore offline + Hive 백업 |
| 기록 히스토리 | ⚠️ 최근 7일만 | 페이징 시 서버 조회 |
| 유저 정보 | ✅ 캐싱 | 로그인 시 저장 |

### Hive Box 구조

```dart
// data/local/hive_boxes.dart
class HiveBoxes {
  static const String monsterCatalog = 'monster_catalog';  // 전체 몬스터
  static const String todayRecords = 'today_records';      // 오늘 기록
  static const String userMonsters = 'user_monsters';      // 보유 몬스터
  static const String userProfile = 'user_profile';        // 유저 정보
}
```

### 동기화 전략

```
앱 시작
   ↓
[로컬 캐시 먼저 로드] → UI 즉시 표시
   ↓
[백그라운드 서버 동기화]
   ↓
┌────────────────┐
│ 변경사항 있음?  │
└───────┬────────┘
        ↓ Yes
[로컬 캐시 업데이트] → UI 갱신
```

### Firestore Offline Persistence

```dart
// Firebase 초기화 시 설정
await FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,        // 오프라인 캐시 활성화
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

---

## UseCase 레이어 (향후 검토)

현재는 Provider에서 직접 Repository를 호출하지만, 비즈니스 로직이 복잡해지면 UseCase 레이어 도입 검토.

### 도입 시점

- 하나의 액션이 여러 Repository를 호출할 때
- 트랜잭션 처리가 필요할 때
- 비즈니스 규칙이 복잡해질 때

### 예시: 기록 생성 UseCase

```dart
// domain/usecases/create_record_usecase.dart
class CreateRecordUseCase {
  final IRecordRepository _recordRepo;
  final IMonsterCatalogRepository _catalogRepo;
  final IUserMonsterRepository _userMonsterRepo;

  Future<CreateRecordResult> execute(Record record) async {
    // 1. 기록 저장
    final recordId = await _recordRepo.createRecord(record);

    // 2. 해당 카테고리 기록 수 조회
    final count = await _recordRepo.getCategoryCount(record.categoryKey);

    // 3. 해금 조건 체크
    final monster = await _catalogRepo.checkUnlockCondition(
      categoryKey: record.categoryKey,
      count: count,
    );

    // 4. 신규 몬스터 해금
    if (monster != null) {
      final existing = await _userMonsterRepo.getById(monster.id);
      if (existing == null) {
        await _userMonsterRepo.unlock(monster.id);
        return CreateRecordResult.newMonster(monster);
      } else {
        await _userMonsterRepo.incrementSummonCount(monster.id);
        return CreateRecordResult.existingMonster(monster);
      }
    }

    return CreateRecordResult.noMonster();
  }
}
```

**MVP에서는 Provider에서 직접 처리해도 무방**
