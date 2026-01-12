# 몬스터 이미지 에셋 폴더

이 폴더에는 AI로 생성한 몬스터 이미지들이 저장됩니다.

## 📁 폴더 구조

```
monsters/
├── food/           # 식습관 몬스터
├── sleep/          # 수면 몬스터
├── exercise/       # 운동 몬스터
├── money/          # 소비 몬스터
└── productivity/   # 생산성 몬스터
```

## 📝 파일 명명 규칙

```
{category}_{id}_{expression}.png

예시:
- food_001_idle.png
- food_001_happy.png
- food_001_sleep.png
```

## 🎨 이미지 사양

- **포맷**: PNG (투명 배경)
- **크기**: 256x256px (@2x)
- **최적화**: 각 파일 50KB 이하
- **표정**: idle (기본), happy (기쁨), sleep (졸림)

## 📖 참고 문서

- 프롬프트 가이드: `docs/technical/08-image-generation-prompts.md`
- 비주얼 컨셉: `docs/planning/05-visual-concept.md`

## 🚀 다음 단계

1. AI 도구로 이미지 생성 (Midjourney/DALL-E)
2. 배경 제거 (Remove.bg)
3. 크기 조정 및 최적화 (TinyPNG)
4. 파일명 규칙에 맞춰 저장
5. 해당 카테고리 폴더에 배치

## ✅ 생성 대상 (총 99개)

- [ ] food (9개 × 3표정 = 27개)
- [ ] sleep (9개 × 3표정 = 27개)
- [ ] exercise (3개 × 3표정 = 9개)
- [ ] money (6개 × 3표정 = 18개)
- [ ] productivity (6개 × 3표정 = 18개)

**총**: 33개 몬스터 × 3표정 = 99개 PNG 파일
