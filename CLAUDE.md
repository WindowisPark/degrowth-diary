# 퇴화일기 (Degrowth Diary)

나쁜 습관 기록하면 몬스터가 생기는 역설적 자기계발 앱

## Quick Reference

```bash
# 실행
flutter run

# 빌드
flutter build apk --release
flutter build ios --release

# 테스트
flutter test

# 의존성
flutter pub get

# 코드 생성 (freezed, json_serializable 등)
flutter pub run build_runner build --delete-conflicting-outputs
```

## 기술 스택

- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Backend**: Firebase (Auth, Firestore, FCM, Storage, Functions)
- **Local Storage**: Hive (오프라인 캐싱)

## 문서 위치

**작업 전 반드시 docs/ 폴더의 문서를 확인할 것**

- `docs/planning/` - 프로젝트 개요, 기능 정의, 로드맵
- `docs/technical/` - 기술 스택, 아키텍처, 데이터 스키마, 화면 흐름

---

## 아키텍처 원칙

### 레이어 구조 (Clean Architecture)

```
Presentation (UI/Widgets)
     ↓ 의존
Providers (Riverpod State)
     ↓ 의존
Domain (Interface/Entity)
     ↓ 의존
Data (Firebase 구현체)
```

**의존성 규칙**: 상위 레이어는 하위 레이어에 의존. 역방향 의존 금지.

### 폴더별 역할

| 폴더 | 역할 | Firebase 의존성 |
|------|------|-----------------|
| `domain/entities/` | 순수 데이터 클래스 | 없음 |
| `domain/repositories/` | 추상 인터페이스 | 없음 |
| `data/models/` | DTO (toJson/fromJson) | Timestamp 등 |
| `data/firebase/` | Repository 구현체 | 있음 |
| `data/local/` | Hive 로컬 캐시 | 없음 |
| `core/errors/` | Failure 클래스 | 없음 |
| `providers/` | DI 설정 + 상태관리 | ref로 주입 |
| `presentation/` | UI 위젯 | 없음 |

### Repository 책임 분리

```dart
// 글로벌 몬스터 도감 (monsters 컬렉션)
IMonsterCatalogRepository  → FirebaseMonsterCatalogRepository

// 유저 소유 몬스터 (users/{id}/userMonsters)
IUserMonsterRepository     → FirebaseUserMonsterRepository
```

### Entity vs Model 분리

```dart
// domain/entities/record.dart - 순수 (Firebase 모름)
class Record {
  final String id;
  final DateTime createdAt;  // 순수 DateTime
}

// data/models/record_model.dart - Firebase 변환 담당
class RecordModel {
  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
  Record toEntity() => Record(...);
}
```

### Riverpod DI 패턴

```dart
// 인터페이스 타입으로 제공 - 구현체 교체 용이
final recordRepositoryProvider = Provider<IRecordRepository>((ref) {
  return FirebaseRecordRepository(
    FirebaseFirestore.instance,
    ref.watch(authRepositoryProvider),
  );
});
```

---

## Firestore 데이터 설계 원칙

### 1. 비정규화 (Denormalization)

**RDB와 다름**: Firestore는 JOIN이 없음. 읽기 최적화를 위해 데이터 중복 허용.

```
BAD:  record.userId로 users 컬렉션 별도 조회 (2회 읽기)
GOOD: users/{userId}/records/{recordId} 서브컬렉션 (1회 읽기)
```

### 2. 참조 방식 - 단방향 유지

**Spring과의 차이**: JPA처럼 양방향 관계 설정 불가. 단방향 참조만 사용.

```javascript
// GOOD: monsters에서 evolution 단방향 참조
monsters/{monsterId} {
  evolutionTo: "monster_002"  // 단방향만
}

// BAD: 양방향 참조 시도 (데이터 불일치 위험)
monsters/{monsterId} {
  evolutionTo: "monster_002",
  evolutionFrom: "monster_001"  // 동기화 어려움
}
```

### 3. 순환 참조 방지

**문서 간 상호 참조 금지**: A→B→A 형태의 참조 체인 만들지 않음.

```javascript
// BAD: record가 monster를, monster가 record를 참조
records/{id} { monsterId: "m1" }
monsters/m1 { lastRecordId: "r1" }  // 순환!

// GOOD: 한 방향만 참조 + 필요시 쿼리
records/{id} { monsterId: "m1" }
// monster의 records는 쿼리로 조회
```

### 4. 컬렉션 구조

```
users/{userId}
  ├── records/{recordId}        # 서브컬렉션
  ├── userMonsters/{monsterId}  # 서브컬렉션
  └── achievements/{id}         # 서브컬렉션

monsters/{monsterId}            # 글로벌 (모든 유저 공유)
```

### 5. 집계 필드 보호

**클라이언트 write 금지 필드**: Cloud Functions에서만 업데이트

```javascript
users/{userId} {
  streakCount: number,      // 클라 write 금지
  lastRecordDate: string,   // 클라 write 금지
  lastRecordAt: timestamp   // 클라 write 금지
}
```

### 6. 쿼리 최적화

```dart
// BAD: 클라에서 전체 조회 후 필터링
final all = await records.get();
final filtered = all.where((r) => r.date == today);

// GOOD: Firestore 쿼리로 필터링
final today = await records
    .where('recordDate', isEqualTo: '2026-01-09')
    .get();
```

---

## 코드 스타일

### Dart/Flutter

- **Null safety** 엄격 적용
- **freezed** 사용 시 immutable 패턴
- Provider 이름: `xxxProvider` (예: `recordRepositoryProvider`)
- 비동기: `AsyncValue` 활용 (loading/error/data 상태)

### 네이밍 컨벤션

| 종류 | 형식 | 예시 |
|------|------|------|
| 파일 | snake_case | `record_model.dart` |
| 클래스 | PascalCase | `RecordModel` |
| 변수/함수 | camelCase | `getTodayRecords()` |
| 상수 | camelCase | `maxSeverity = 5` |
| 인터페이스 | I 접두사 | `IRecordRepository` |

### 카테고리 enum key 방식

```dart
// 하드코딩 금지
categoryKey: "food"        // GOOD
categoryKey: "식습관"       // BAD (다국어 대응 어려움)
```

---

## 중요 제약사항

1. **severity 범위**: 1~5 (Security Rules에서 검증)
2. **createdAt**: 서버 타임스탬프 강제 (`request.time`)
3. **recordDate**: "YYYY-MM-DD" 문자열 (집계용, 수정 불가)
4. **hasMonster 플래그**: Firestore null 쿼리 이슈 방지용

---

## 주의사항

### Stream vs Future

```dart
// Firebase: 실시간 스트림 지원
Stream<List<Record>> watchTodayRecords();

// REST API 교체 시: polling 또는 미지원
```

### 오프라인 대응

| 데이터 | 캐싱 | 전략 |
|--------|------|------|
| 몬스터 도감 | 전체 | 앱 시작 시 동기화 |
| 오늘 기록 | O | Firestore offline + Hive |
| 유저 몬스터 | O | Firestore offline + Hive |
| 기록 히스토리 | 최근 7일 | 페이징 시 서버 조회 |

### Error Handling

```dart
// sealed class로 에러 타입 정의
sealed class Failure {
  final String message;
}
class NetworkFailure extends Failure { ... }
class ServerFailure extends Failure { ... }

// AsyncValue.when()으로 UI 처리
ref.watch(provider).when(
  data: (data) => ...,
  loading: () => ...,
  error: (e, _) => ErrorView(message: e is Failure ? e.message : '오류'),
);
```

### 테스트

- Repository 테스트: Fake 구현체 주입
- Provider 테스트: `ProviderContainer` override
- Widget 테스트: mock provider 사용
