# 캐릭터 디자인 가이드

## 스타일 가이드

### 확정 스타일

- **아웃라인**: 굵은 검정 라인
- **채색**: 플랫, 그라데이션 최소화
- **색감**: 탁한 파스텔 (너무 유치하지 않게)
- **표정**: 멍청하거나 찐 미소, 반쯤 감은 눈
- **전체 무드**: "귀엽지만 어딘가 나사 빠진"

### 캐릭터 규칙

- **사이즈**: 512x512px 기본
- **눈**: 동그란 점 or 반달 (졸린 표정)
- **표정 종류**: 기본 / 행복 / 멍함 / 졸림
- **배경**: 투명 or 흰색

---

## 기본 프롬프트 템플릿

### 스타일 정의 (공통)

```
Simple vector character, thick black outline,
flat coloring, muted pastel colors,
cute but slightly dumb expression,
minimal details, app mascot style,
white background
```

### 속성별 컬러 키워드

| 속성 | 컬러 키워드 | Hex |
| --- | --- | --- |
| 🍖 탐식 | orange, warm peach | #FF6B35 |
| 😴 나태 | purple, lavender, soft violet | #7B68EE |
| 💸 탕진 | gold, yellow, sparkle | #FFD700 |
| 📱 중독 | blue, cyan, digital | #4ECDC4 |
| 🍺 탈선 | green, mint, hazy | #98D8AA |
| 👻 회피 | gray, transparent, fading | #A0A0A0 |

---

## 속성별 몬스터 프롬프트

### 🍖 탐식 속성

#### 야식이 → 야식귀신 → 야식대마왕

**트리거**: 야식

```
[1단계: 야식이]
A cute small fried chicken drumstick character with tiny eyes and legs,
simple vector style, thick black outline,
flat orange and cream colors,
app mascot, white background
```

```
[2단계: 야식귀신]
A cute ghost character wearing a delivery food box as a hat,
holding fried chicken, greasy happy expression,
simple vector style, thick black outline,
flat orange and white colors,
app mascot, white background
```

```
[3단계: 야식대마왕]
A large cute monster made of combined delivery food boxes,
chicken wings as arms, pizza slice crown,
simple vector style, thick black outline,
flat orange and red colors,
app mascot, white background
```

#### 폭풍흡입

**트리거**: 폭식

```
A cute slime character with a black hole mouth,
always hungry expression, round body,
simple vector style, thick black outline,
flat orange and dark colors,
app mascot, white background
```

#### 배달의기수

**트리거**: 배달 3연속

```
A small cute devil riding a delivery motorcycle,
rushed expression, helmet with horns,
simple vector style, thick black outline,
flat orange and black colors,
app mascot, white background
```

---

### 😴 나태 속성

#### 이불리 → 이불대왕

**트리거**: 늦잠

```
[1단계: 이불리]
A cute blob character wrapped in a cozy blanket,
half-closed sleepy eyes, peaceful smile,
simple vector style, thick black outline,
flat purple and white colors,
app mascot, white background
```

```
[2단계: 이불대왕]
A cute monster that IS the entire bed,
blanket body with sleepy face, pillow crown,
simple vector style, thick black outline,
flat purple and cream colors,
app mascot, white background
```

#### 내일령

**트리거**: 미루기

```
A small cute fairy flipping calendar pages,
lazy relaxed expression, floating,
simple vector style, thick black outline,
flat purple and white colors,
app mascot, white background
```

#### 소파감자

**트리거**: 운동 스킵

```
A cute potato character melted into a sofa,
comfy expression, roots growing into cushions,
simple vector style, thick black outline,
flat purple and brown colors,
app mascot, white background
```

---

### 💸 탕진 속성

#### 텅장령

**트리거**: 과소비

```
A cute ghost emerging from an empty wallet,
sad but unrepentant expression, sparkles around,
simple vector style, thick black outline,
flat gold and gray colors,
app mascot, white background
```

#### 카드귀신

**트리거**: 카드값 폭발

```
A cute credit card character with tiny arms and legs,
running away expression, swipe marks behind,
simple vector style, thick black outline,
flat gold and black colors,
app mascot, white background
```

#### 현질요정

**트리거**: 게임 현질

```
A sparkly cute fairy sprinkling gold dust,
hypnotizing expression, gem wings,
simple vector style, thick black outline,
flat gold and pink colors,
app mascot, white background
```

---

### 📱 중독 속성

#### 스크롤좀비

**트리거**: SNS 과몰입

```
A cute zombie with oversized thumb,
blank tired expression, phone-shaped eyes,
simple vector style, thick black outline,
flat blue and gray colors,
app mascot, white background
```

#### 숏츠유령

**트리거**: 유튜브 3시간+

```
A cute ghost with play button face,
hypnotized swirl eyes, floating,
simple vector style, thick black outline,
flat blue and red colors,
app mascot, white background
```

#### 알림정령

**트리거**: 알림 확인 강박

```
A cute anxious spirit with red notification dot on head,
wide nervous eyes, twitchy,
simple vector style, thick black outline,
flat blue and red colors,
app mascot, white background
```

---

### 🍺 탈선 속성

#### 주정령

**트리거**: 음주

```
A cute wobbly water droplet character,
happy then sad expression, slightly melting,
simple vector style, thick black outline,
flat green and transparent colors,
app mascot, white background
```

#### 카페인령

**트리거**: 커피 과다

```
A cute shaking coffee bean character,
wide awake eyes, vibrating lines around,
simple vector style, thick black outline,
flat green and brown colors,
app mascot, white background
```

#### 니코틴령

**트리거**: 흡연

```
A cute ghost made of smoke,
fading wispy body, constantly rising up,
simple vector style, thick black outline,
flat green and gray colors,
app mascot, white background
```

---

### 👻 회피 속성

#### 읽씹이

**트리거**: 읽고 안 답함

```
A cute ghost becoming transparent,
avoiding eye contact, fading away,
simple vector style, thick black outline,
flat gray and white colors,
app mascot, white background
```

#### 잠수도깨비

**트리거**: 연락 두절

```
A cute goblin peeking from underwater,
only eyes visible, bubbles around,
simple vector style, thick black outline,
flat gray and blue colors,
app mascot, white background
```

#### 펑크요정

**트리거**: 약속 취소

```
A cute fairy that is a popping balloon,
apologetic expression, deflating,
simple vector style, thick black outline,
flat gray and pink colors,
app mascot, white background
```

---

## 특수 몬스터 프롬프트

### 복합체

**조건**: 하루에 3속성 기록

```
A cute chimera monster with three different colored sections,
confused expression, mixed features,
simple vector style, thick black outline,
flat orange purple and blue colors,
app mascot, white background
```

### 작심삼일이

**조건**: 3일 연속 → 중단 3회 반복

```
A cute character holding a "Day 3" sign,
proud but guilty expression, tiny calendar behind,
simple vector style, thick black outline,
flat rainbow pastel colors,
app mascot, white background
```

### 반성령

**조건**: 7일 연속 기록 후 3일 공백

```
A small cute halo ghost,
peaceful reformed expression, faint glow,
simple vector style, thick black outline,
flat white and gold colors,
app mascot, white background
```

---

## 시즌 한정 몬스터

### 🏖 여름: 냉방병령

```
A cute shivering ghost hugging an AC unit,
freezing expression, ice crystals around,
simple vector style, thick black outline,
flat blue and white colors,
app mascot, white background
```

### 🎄 연말: 폭식산타

```
A cute chubby Santa character surrounded by food,
stuffed happy expression, delivery bags,
simple vector style, thick black outline,
flat red orange and white colors,
app mascot, white background
```

### 🎊 새해: 작심일일이

```
A cute character with "Jan 1" hat,
over-confident expression, long todo list,
simple vector style, thick black outline,
flat gold and white colors,
app mascot, white background
```

---

## MVP 우선순위 (10종)

| 순위 | 몬스터 | 속성 | 이유 |
| --- | --- | --- | --- |
| 1 | 야식귀신 | 탐식 | 가장 공감대 높음 |
| 2 | 이불리 | 나태 | 귀여움 극대화 |
| 3 | 스크롤좀비 | 중독 | 현대인 필수 |
| 4 | 내일령 | 나태 | 미루기 공감 |
| 5 | 텅장령 | 탕진 | 월급날 공감 |
| 6 | 읽씹이 | 회피 | 관계 공감 |
| 7 | 소파감자 | 나태 | 운동 스킵 공감 |
| 8 | 카페인령 | 탈선 | 직장인 공감 |
| 9 | 숏츠유령 | 중독 | 유튜브 공감 |
| 10 | 작심삼일이 | 특수 | 앱 마스코트급 |

---

## 이미지 생성 팁

### 도구별 특징

- **Midjourney**: 퀄리티 최상, --niji 파라미터로 캐릭터 특화
- **Leonardo.ai**: 무료 크레딧, Character Reference로 일관성 유지
- **DALL-E 3**: ChatGPT 연동, 프롬프트 이해도 높음

### 일관성 유지 방법

1. 같은 스타일 프롬프트 템플릿 유지
2. 생성된 이미지 중 기준 이미지 선정
3. 해당 이미지를 레퍼런스로 계속 사용
4. 컬러 팔레트 고정

### 후처리 플로우

```
AI 생성 (PNG)
    ↓
remove.bg (배경 제거)
    ↓
Vectorizer.ai (벡터 변환)
    ↓
Figma (색상/비율 통일)
    ↓
앱 적용
```
