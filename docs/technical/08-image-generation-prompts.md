# AI 이미지 생성 프롬프트 가이드

**목적**: Midjourney, DALL-E, Stable Diffusion 등 AI 도구로 몬스터 이미지를 생성하기 위한 프롬프트 템플릿

**참고 문서**: [05-visual-concept.md](../planning/05-visual-concept.md)

---

## 📐 기본 설정

### 공통 기술 요구사항

모든 프롬프트에 포함해야 할 공통 요소:

```
- transparent background PNG
- single character centered
- kawaii dark fantasy style
- Don't Starve inspired aesthetic
- chibi proportions
- no text, no UI elements
- clean edges
--ar 1:1 --v 6
```

### 표정 시스템

각 몬스터당 3가지 표정:
- **Idle (기본)**: 평화로운 표정
- **Happy (기쁨)**: 입 벌리고 기쁜 표정
- **Sleep (졸림)**: 눈 감고 Z 표시

---

## 🎨 프롬프트 작성 공식

```
[몬스터 기본 형태] + [카테고리 특징] + [희귀도 효과] + [스타일] + [기술 요구사항]
```

### 희귀도별 수식어

- **Common**: `simple design, cute, small size, basic colors`
- **Rare**: `glowing subtle aura, soft particle effects, mysterious atmosphere`
- **Epic**: `powerful presence, dramatic lighting, magical glow, larger size`
- **Legendary**: `majestic, golden rays, epic atmosphere, screen-filling presence`

---

## 🍔 Food Type (식습관) - 빨강 계열

### food_001: 야식이 (Common)

**설명**: 통통한 몸에 큰 입, 항상 배고픈 표정

#### Idle
```
cute chubby round red monster, big drooling mouth with sharp teeth,
short stubby legs and arms, chicken bone decoration on head,
hungry expression with big eyes, kawaii dark fantasy style,
Don't Starve inspired, simple design, red and pink colors,
transparent background PNG, centered character, chibi proportions,
no text, no UI --ar 1:1 --v 6
```

#### Happy
```
cute chubby round red monster, big WIDE open mouth smiling,
short stubby legs and arms, chicken bone decoration on head,
excited happy expression with sparkle eyes, eating motion,
kawaii dark fantasy style, red and pink colors,
transparent background PNG --ar 1:1 --v 6
```

#### Sleep
```
cute chubby round red monster, eyes closed sleeping peacefully,
short stubby legs and arms, chicken bone decoration on head,
small Z symbols floating above head, peaceful sleeping expression,
kawaii dark fantasy style, red and pink colors,
transparent background PNG --ar 1:1 --v 6
```

---

### food_002: 야식귀신 (Rare)

**설명**: 반투명한 유령, 스마트폰 들고 있음

#### Idle
```
semi-transparent ghost monster, red and purple gradient body,
holding smartphone glowing screen, floating pizza and chicken pieces around,
tired eyes with dark circles, spooky but cute, larger than basic form,
glowing subtle blue aura, mysterious nighttime atmosphere,
kawaii dark fantasy style, transparent background PNG --ar 1:1 --v 6
```

---

### food_003: 야식대마왕 (Epic)

**설명**: 거대한 몸집, 음식 왕관, 냉장고 같은 배

#### Idle
```
large powerful demon monster, refrigerator-shaped belly, food crown on head,
multiple arms holding various foods, satisfied evil grin expression,
wine red and gold accent colors, dramatic dark lighting,
magical food glow particles, epic powerful presence,
kawaii dark fantasy boss monster style, transparent background PNG --ar 1:1 --v 6
```

---

## 💤 Sleep Type (수면) - 보라 계열

### sleep_001: 늦잠이 (Common)

**설명**: 구름 같은 형태, 알람시계 장식

#### Idle
```
fluffy cloud-shaped purple monster, always eyes closed,
alarm clock decoration on head, small Z symbols floating,
bottom slightly melting dripping downward, drowsy sleepy expression,
lavender and white highlight colors, simple cute design,
kawaii dark fantasy style, transparent background PNG --ar 1:1 --v 6
```

#### Happy
```
fluffy cloud-shaped purple monster, eyes barely open with smile,
alarm clock decoration on head, happy but still drowsy,
lavender colors, kawaii dark fantasy style,
transparent background PNG --ar 1:1 --v 6
```

#### Sleep
```
fluffy cloud-shaped purple monster, completely asleep,
alarm clock decoration on head, multiple Z symbols floating,
very peaceful expression, lavender colors,
transparent background PNG --ar 1:1 --v 6
```

---

### sleep_002: 불면령 (Rare)

**설명**: 보라빛 유령, 다크서클, 스마트폰

#### Idle
```
vertically elongated ghost monster, dark purple gradient,
heavy dark circles under eyes, holding glowing smartphone,
night sky pattern with stars and moon on body, blue light glow from phone,
tired but alert wide eyes, glowing mysterious aura,
kawaii dark fantasy style, transparent background PNG --ar 1:1 --v 6
```

---

### sleep_003: 수면파괴자 (Epic)

**설명**: 거대한 악마, 알람시계 뿔, 날개

#### Idle
```
large demon monster with alarm clock-shaped horns, exhausted drooping wings,
coffee cup and energy drink patterns on body, pink caffeine aura glow,
zombie-like awakened expression with wide bloodshot eyes, dark purple body,
dramatic epic lighting, powerful but tired presence,
kawaii dark fantasy boss monster, transparent background PNG --ar 1:1 --v 6
```

---

## 🛋️ Exercise Type (운동) - 청록 계열

### exercise_001: 나태충 (Common)

**설명**: 애벌레 형태, 소파 쿠션 모자

#### Idle
```
caterpillar-like lazy monster lying on belly, stubby short limbs,
sofa cushion hat on head, "내일부터" text pattern on body,
completely lethargic expression, mint green and gray colors,
simple cute design, kawaii dark fantasy style,
transparent background PNG --ar 1:1 --v 6
```

#### Happy
```
caterpillar-like lazy monster, slight smile but still lying down,
sofa cushion hat, relaxed happy expression, mint green colors,
kawaii dark fantasy style, transparent background PNG --ar 1:1 --v 6
```

#### Sleep
```
caterpillar-like lazy monster, fully asleep with Z symbols,
sofa cushion hat, completely peaceful sleeping, mint green colors,
transparent background PNG --ar 1:1 --v 6
```

---

### exercise_002: 게으름보 (Rare)

**설명**: 나무늘보, 소파에 녹아붙음

#### Idle
```
sloth-like monster melted into beige sofa, remote control in one hand,
snack bag in other hand, dust particles floating around body,
extremely peaceful lazy expression, teal and beige colors,
glowing lazy aura, kawaii dark fantasy style,
transparent background PNG --ar 1:1 --v 6
```

---

### exercise_003: 만년소파인 (Epic)

**설명**: 소파와 융합, 헬스장 회원권 화석

#### Idle
```
massive monster fused with old brown sofa, multiple arms multitasking
gaming and watching Netflix, fossilized gym membership card nearby,
satisfied lazy smile, lazy aura affecting surroundings, dark teal and brown colors,
dramatic epic couch potato presence, kawaii dark fantasy boss monster,
transparent background PNG --ar 1:1 --v 6
```

---

## 💰 Money Type (소비) - 금색 계열

### money_001: 충동이 (Common)

**설명**: 동전 모양, 작은 날개, 카드

#### Idle
```
coin-shaped cute monster with big sparkling eyes, tiny angel wings but devil,
holding credit card, "이건 사야 해!" speech bubble nearby,
bright gold and white sparkle colors, simple innocent design,
kawaii dark fantasy style, transparent background PNG --ar 1:1 --v 6
```

#### Happy
```
coin-shaped cute monster, extremely excited sparkle eyes wide open,
tiny wings flapping, holding credit card with joy, bright gold colors,
kawaii dark fantasy style, transparent background PNG --ar 1:1 --v 6
```

#### Sleep
```
coin-shaped cute monster, eyes closed peacefully, tiny wings relaxed,
still holding credit card, small Z symbols, bright gold colors,
transparent background PNG --ar 1:1 --v 6
```

---

### money_002: 과소비령 (Rare)

**설명**: 쇼핑백 유령, 카드 광선

#### Idle
```
ghost monster wearing shopping bag as hood, credit card beam from hands,
shopping bags and delivery boxes floating around, red SALE sign glowing on head,
receipts flying everywhere, gold and orange gradient colors,
glowing shopping aura, kawaii dark fantasy style,
transparent background PNG --ar 1:1 --v 6
```

---

### money_003: 통장귀신 (Epic)

**설명**: 거대한 악마, 텅 빈 지갑 몸

#### Idle
```
massive demon monster with empty wallet-shaped body, multiple arms shopping simultaneously,
card/cash/transfer crown on head, "-10000" "-50000" red minus effects floating,
evil but warm smile, dark gold and red minus colors,
dramatic epic spending presence, golden particle effects,
kawaii dark fantasy boss monster, transparent background PNG --ar 1:1 --v 6
```

---

## 📱 Productivity Type (생산성) - 초록 계열

### productivity_001: 폰좀비 (Common)

**설명**: 좀비, 고개 숙임, 블루라이트

#### Idle
```
small zombie monster with head bowed down to phone, blue light from eyes,
one hand scrolling motion endlessly, feet slightly floating focused,
lime green and blue light colors, simple addicted design,
kawaii dark fantasy style, transparent background PNG --ar 1:1 --v 6
```

#### Happy
```
small zombie monster, still looking at phone but smiling,
blue light from eyes, excited scrolling motion, lime green colors,
kawaii dark fantasy style, transparent background PNG --ar 1:1 --v 6
```

#### Sleep
```
small zombie monster, phone dropped, eyes closed with Z symbols,
still in scrolling hand position habitually, lime green colors,
transparent background PNG --ar 1:1 --v 6
```

---

### productivity_002: 미루기왕 (Rare)

**설명**: 왕좌, "5분만 더" 깃발

#### Idle
```
king monster sitting on throne confidently, "5분만 더" flag in one hand,
time-warped clock in other hand, unfinished work piles around,
"내일부터" text on crown, relaxed ruler expression, emerald green and yellow colors,
glowing procrastination aura, kawaii dark fantasy style,
transparent background PNG --ar 1:1 --v 6
```

---

### productivity_003: 시간도둑 (Epic)

**설명**: 거대한 도둑, 망토 안 시계들

#### Idle
```
massive thief monster with hourglass-shaped body, cloak full of clocks inside,
black hole in hands sucking time, "하루가 어떻게 갔지" time distortion aura,
mysterious knowing smile, dark green and time distortion effects,
dramatic epic time-thief presence, kawaii dark fantasy boss monster,
transparent background PNG --ar 1:1 --v 6
```

---

## ⭐ Special Monsters (희귀 몬스터)

### food_special_001: 심야 배달 고블린 (Rare)

**설명**: 고블린, 배달 가방, 달빛 실루엣

```
goblin monster wearing delivery bag, holding chicken box in one hand,
smartphone delivery app in other hand, clock showing 23:00-02:00,
silhouette under moonlight atmosphere, nighttime mystery vibe,
red and night gradient colors, glowing rare aura,
kawaii dark fantasy style, transparent background PNG --ar 1:1 --v 6
```

---

### food_special_002: 금요일 폭식 드래곤 (Epic)

**설명**: 드래곤, TGIF 날개, 치맥 브레스

```
small but confident dragon monster, "TGIF" text pattern on wings,
breathing chimaek breath from mouth, soju bottle-shaped tail,
Friday party celebration atmosphere, festival particles everywhere,
wine red and gold accent colors, dramatic epic Friday vibes,
kawaii dark fantasy dragon, transparent background PNG --ar 1:1 --v 6
```

---

### sleep_special_001: 불면증 드래곤 (Epic)

**설명**: 거대한 드래곤, 침대, 눈 뜨고 있음

```
massive dragon monster lying on bed but eyes wide open,
wings wrapped like blanket covering body, floating worries around,
night sky star particles, clock showing 00:00-04:00,
dark purple and neon blue colors, dramatic epic insomnia presence,
kawaii dark fantasy dragon, transparent background PNG --ar 1:1 --v 6
```

---

### productivity_special_001: 월요병 슬라임 (Rare)

**설명**: 슬라임, 녹아내림, 출근 가방

```
melted slime monster completely drooping downward, "월요일..." speech bubble,
dragging work bag on ground heavily, depressed blue and gray colors,
depression particles floating upward slowly, Monday blues aura,
glowing rare sadness effect, kawaii dark fantasy style,
transparent background PNG --ar 1:1 --v 6
```

---

### productivity_special_002: 주말 낭비왕 (Epic)

**설명**: 왕, 침대 왕좌, 잠옷

```
king monster fused with bed throne, weekend crown with "토/일" text,
entire body wearing pajamas, wasted time ghosts floating around,
time melting downward effect, pastel pink and mint colors,
dramatic epic weekend-waster presence, kawaii dark fantasy boss,
transparent background PNG --ar 1:1 --v 6
```

---

### money_special_001: 페이데이 악마 (Legendary)

**설명**: 전설의 악마, 거대한 날개, 돈 몸

```
LEGENDARY massive demon monster with giant wings, body made of money coins,
credit card beams from horns, "-월급" minus effects everywhere,
gold coin rain particles falling like heavy rain, background temporarily golden glow,
warning alert atmosphere, dark red, gold and black epic colors,
majestic golden rays, screen-filling legendary presence,
kawaii dark fantasy ultimate boss, transparent background PNG --ar 1:1 --v 6
```

---

## 🎯 프롬프트 사용 팁

### Midjourney
1. `/imagine` 명령어 사용
2. 프롬프트 끝에 `--ar 1:1 --v 6` 추가
3. 결과물 중 가장 마음에 드는 것 선택 후 Upscale
4. 배경 제거: Remove.bg 또는 Photoshop

### DALL-E 3
1. ChatGPT Plus에서 사용
2. 프롬프트에서 `--ar 1:1 --v 6` 제거
3. "transparent background"  강조
4. 결과물 다운로드 후 배경 제거

### Stable Diffusion
1. Model: Anything V3 또는 DreamShaper
2. Negative Prompt: `background, text, watermark, signature, blur`
3. Steps: 30-50
4. CFG Scale: 7-10
5. 결과물 PNG 저장

---

## 📏 이미지 후처리

### 1. 배경 제거
- Remove.bg (무료: 월 50장)
- Photopea (무료 포토샵 대체)
- GIMP (무료 오픈소스)

### 2. 크기 조정
- 기본 크기: 256x256px (@2x)
- Common: 60-70px
- Rare: 70-80px
- Epic: 80-100px
- Legendary: 100-120px

### 3. 최적화
- TinyPNG (https://tinypng.com) - PNG 압축
- 목표: 각 파일 50KB 이하

### 4. 파일 명명 규칙
```
{category}_{id}_{expression}.png

예시:
- food_001_idle.png
- food_001_happy.png
- food_001_sleep.png
- sleep_special_001_idle.png
```

---

## 📦 배치 생성 전략

### 우선순위 1: Common 몬스터 (15개)
가장 자주 보이는 몬스터이므로 먼저 생성
- food_001, sleep_001, exercise_001, money_001, productivity_001

### 우선순위 2: 진화형 (10개)
- Stage 2, Stage 3 몬스터

### 우선순위 3: Special 몬스터 (8개)
시간대/요일 조건 몬스터

---

## 🚨 주의사항

1. **일관성**: 같은 몬스터의 3가지 표정은 동일한 base prompt 사용
2. **투명 배경**: 반드시 확인 (흰색 배경 시 다시 생성)
3. **해상도**: 최소 256x256px (나중에 축소 가능)
4. **스타일**: "kawaii dark fantasy" 키워드 필수 유지
5. **상업적 이용**: Midjourney Commercial 라이선스 확인

---

## ✅ 체크리스트

이미지 생성 완료 후 확인:
- [ ] PNG 포맷, 투명 배경
- [ ] 파일명 규칙 준수
- [ ] 크기 최적화 (50KB 이하)
- [ ] 카테고리별 폴더 정리
- [ ] 3가지 표정 모두 생성 (idle/happy/sleep)
- [ ] 비주얼 컨셉 문서와 일치하는지 확인

---

## 📚 참고 링크

- [Midjourney](https://www.midjourney.com)
- [DALL-E 3 (ChatGPT Plus)](https://chat.openai.com)
- [Stable Diffusion Web UI](https://github.com/AUTOMATIC1111/stable-diffusion-webui)
- [Remove.bg](https://www.remove.bg)
- [TinyPNG](https://tinypng.com)
- [Don't Starve Art Style Reference](https://dontstarve.fandom.com/wiki/Don%27t_Starve_Wiki)

---

**생성 시작일**: 2026-01-12

**예상 소요 시간**: 3-5시간 (AI 도구 + 후처리)

**총 이미지 수**: 33개 몬스터 × 3표정 = 99개 PNG 파일
