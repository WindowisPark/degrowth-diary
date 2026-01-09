# 데이터 스키마

## 설계 원칙

| 항목 | 결정 |
| --- | --- |
| 집계 필드 | 서버(Cloud Functions)만 write |
| 카테고리 | enum key 방식 |
| 날짜 필드 | recordDate 추가 ("2026-01-06") |
| 보안 | 필드 검증 + 집계 보호 |

---

## Firestore 구조

### users/{userId}

```js
{
  // 기본 정보
  nickname: string,
  createdAt: timestamp,
  updatedAt: timestamp,
  timezone: string,               // "Asia/Seoul"

  // 집계 (서버만 write)
  streakCount: number,            // ⚠️ 클라 write 금지
  lastRecordDate: string,         // ⚠️ 클라 write 금지 ("2026-01-06")
  lastRecordAt: timestamp,        // ⚠️ 클라 write 금지

  // 설정 (클라 write 가능)
  settings: {
    pushEnabled: boolean,
    pushTime: string,             // "21:00"
    darkMode: boolean
  }
}
```

### records 서브컬렉션

```js
users/{userId}/records/{recordId}
{
  categoryKey: string,            // enum key: "food", "sleep", ...
  subCategoryKey: string,         // enum key: "late_night", "binge", ...
  severity: number,               // 1~5 (보안규칙 검증)
  memo: string | null,

  recordDate: string,             // "2026-01-06" (집계용)
  createdAt: timestamp,           // 서버 타임스탬프 강제

  hasMonster: boolean,
  monsterId: string | null
}
```

### userMonsters 서브컬렉션

```js
users/{userId}/userMonsters/{monsterId}
{
  level: number,
  exp: number,
  summonCount: number,            // 누적 소환 횟수
  unlockedAt: timestamp
}
```

### achievements 서브컬렉션

```js
users/{userId}/achievements/{achievementId}
{
  unlockedAt: timestamp,
  progress: number | null         // 수치형 업적 대비
}
```

### monsters (글로벌)

```js
monsters/{monsterId}
{
  name: string,
  attribute: string,              // "gluttony", "sloth", ...
  rarity: string,                 // "common", "rare", "epic", "legendary"
  description: string,
  imageUrl: string,

  unlockCondition: {
    categoryKey: string,
    count: number
  },

  evolutionTo: string | null,     // 단방향만 유지
  stage: number                   // 1, 2, 3
}
```

---

## 카테고리 Key 매핑

### 대분류 (CategoryKey)

| Key | 한글 | 이모지 |
| --- | --- | --- |
| food | 식습관 | 🍖 |
| sleep | 수면 | 😴 |
| exercise | 운동/건강 | 🏃 |
| money | 돈 | 💸 |
| productivity | 생산성 | 📱 |
| relationship | 관계 | 👥 |
| habit | 습관 | 🍺 |
| other | 기타 | ❓ |

### 소분류 (SubCategoryKey)

| 대분류 | Key | 한글 |
| --- | --- | --- |
| food | late_night | 야식 |
| food | binge | 폭식 |
| food | delivery | 배달 |
| food | overeat | 과식 |
| sleep | oversleep | 늦잠 |
| sleep | all_nighter | 밤샘 |
| sleep | excessive_nap | 낮잠과다 |
| exercise | skip_workout | 운동 스킵 |
| exercise | skip_stairs | 계단 안 감 |
| money | impulse_buy | 충동구매 |
| money | overspend | 과소비 |
| money | gacha | 현질 |
| productivity | procrastinate | 미루기 |
| productivity | sns_overuse | SNS 과몰입 |
| productivity | youtube | 유튜브 |
| relationship | ghost | 읽씹 |
| relationship | flake | 약속 펑크 |
| habit | alcohol | 음주 |
| habit | smoking | 흡연 |
| habit | caffeine | 카페인 |
| other | custom | 직접 입력 |

---

## 인덱스 설계

| 컬렉션 | 필드 | 용도 |
| --- | --- | --- |
| records | createdAt DESC | 최근 기록 |
| records | recordDate, createdAt | 날짜별 조회 |
| records | categoryKey, createdAt DESC | 카테고리별 |
| records | categoryKey, subCategoryKey, createdAt DESC | 소분류별 |
| userMonsters | unlockedAt DESC | 최근 획득 |

---

## 보안 규칙

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // 유저 문서
    match /users/{userId} {
      // 읽기: 본인만
      allow read: if request.auth != null
                  && request.auth.uid == userId;

      // 생성: 본인만
      allow create: if request.auth != null
                    && request.auth.uid == userId;

      // 수정: 본인 + 집계 필드 보호
      allow update: if request.auth != null
                    && request.auth.uid == userId
                    && !request.resource.data.diff(resource.data)
                        .affectedKeys()
                        .hasAny(['streakCount', 'lastRecordDate', 'lastRecordAt']);

      // records 서브컬렉션
      match /records/{recordId} {
        allow read: if request.auth != null
                    && request.auth.uid == userId;

        // 생성: 필드 검증
        allow create: if request.auth != null
                      && request.auth.uid == userId
                      && request.resource.data.severity >= 1
                      && request.resource.data.severity <= 5
                      && request.resource.data.categoryKey is string
                      && request.resource.data.categoryKey.size() <= 50
                      && request.resource.data.createdAt == request.time;

        // 수정: createdAt, recordDate 변경 금지
        allow update: if request.auth != null
                      && request.auth.uid == userId
                      && !request.resource.data.diff(resource.data)
                          .affectedKeys()
                          .hasAny(['createdAt', 'recordDate']);

        allow delete: if request.auth != null
                      && request.auth.uid == userId;
      }

      // userMonsters
      match /userMonsters/{monsterId} {
        allow read, write: if request.auth != null
                           && request.auth.uid == userId;
      }

      // achievements
      match /achievements/{achievementId} {
        allow read, write: if request.auth != null
                           && request.auth.uid == userId;
      }
    }

    // 글로벌 몬스터
    match /monsters/{monsterId} {
      allow read: if true;
      allow write: if request.auth != null
                   && request.auth.token.admin == true;
    }
  }
}
```

---

## 클라 vs 서버 로직

| 기능 | MVP | 향후 |
| --- | --- | --- |
| streak 계산 | Cloud Functions | 유지 |
| 집계 업데이트 | Cloud Functions | 유지 |
| 몬스터 해금 | 클라이언트 | Cloud Functions |
| 업적 해금 | 클라이언트 | Cloud Functions |

---

## Cloud Functions 목록 (MVP)

### onRecordCreate

기록 생성 시 트리거

```ts
// 실행 내용:
// 1. streak 업데이트
// 2. lastRecordDate 업데이트
// 3. lastRecordAt 업데이트
```

### onRecordDelete

기록 삭제 시 트리거

```ts
// 실행 내용:
// 1. 통계 재계산 (필요 시)
```

### scheduledStreakCheck

매일 자정 스케줄러

```ts
// 실행 내용:
// 1. 어제 기록 없는 유저 streak 리셋
```

---

## 수정 우선순위

### P0: MVP 필수

- [x] 집계 필드 클라 write 금지
- [x] records에 recordDate 추가
- [x] severity 범위 검증
- [x] createdAt 서버 타임스탬프 강제
- [x] timezone 필드 추가
- [x] categoryKey/subCategoryKey enum 방식

### P1: 다음 단계

- [ ] userMonsters.type 제거
- [ ] evolution 단방향 정리
- [ ] stats 집계 문서 분리

### P2: 확장 대비

- [ ] unlockCondition 확장 구조
- [ ] achievements progress 필드 (개발 전 검토 필요)
