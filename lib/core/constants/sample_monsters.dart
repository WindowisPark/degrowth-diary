import '../../domain/entities/monster.dart';

/// 예시 몬스터 데이터 (개발/테스트용)
/// 실제 서비스에서는 Firebase에서 로드
abstract class SampleMonsters {
  static const List<Monster> all = [
    // ===== 식습관 (food) =====
    Monster(
      id: 'food_001',
      name: '야식이',
      attribute: 'food',
      rarity: 'common',
      description: '배달앱을 켜는 순간 어디선가 나타나는 작은 존재',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'food', count: 1),
      evolutionTo: 'food_002',
      stage: 1,
    ),
    Monster(
      id: 'food_002',
      name: '야식귀신',
      attribute: 'food',
      rarity: 'rare',
      description: '새벽 2시, 배달앱을 여는 자의 그림자...',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'food', count: 5),
      evolutionTo: 'food_003',
      stage: 2,
    ),
    Monster(
      id: 'food_003',
      name: '야식대마왕',
      attribute: 'food',
      rarity: 'epic',
      description: '냉장고 문을 열면 항상 그가 있다',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'food', count: 15),
      evolutionTo: null,
      stage: 3,
    ),

    // ===== 수면 (sleep) =====
    Monster(
      id: 'sleep_001',
      name: '늦잠이',
      attribute: 'sleep',
      rarity: 'common',
      description: '알람을 끄는 손가락에 붙어있는 녀석',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'sleep', count: 1),
      evolutionTo: 'sleep_002',
      stage: 1,
    ),
    Monster(
      id: 'sleep_002',
      name: '불면령',
      attribute: 'sleep',
      rarity: 'rare',
      description: '밤이 깊어질수록 강해지는 존재',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'sleep', count: 5),
      evolutionTo: 'sleep_003',
      stage: 2,
    ),
    Monster(
      id: 'sleep_003',
      name: '수면파괴자',
      attribute: 'sleep',
      rarity: 'epic',
      description: '"잠은 죽어서 자라"는 말을 믿게 만드는 자',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'sleep', count: 15),
      evolutionTo: null,
      stage: 3,
    ),

    // ===== 운동 (exercise) =====
    Monster(
      id: 'exercise_001',
      name: '나태충',
      attribute: 'exercise',
      rarity: 'common',
      description: '소파에서 일어나지 못하게 하는 작은 벌레',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'exercise', count: 1),
      evolutionTo: 'exercise_002',
      stage: 1,
    ),
    Monster(
      id: 'exercise_002',
      name: '게으름보',
      attribute: 'exercise',
      rarity: 'rare',
      description: '"내일부터 운동해야지"를 속삭이는 존재',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'exercise', count: 5),
      evolutionTo: 'exercise_003',
      stage: 2,
    ),
    Monster(
      id: 'exercise_003',
      name: '만년소파인',
      attribute: 'exercise',
      rarity: 'epic',
      description: '헬스장 회원권이 먼지 쌓이게 만드는 원흉',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'exercise', count: 15),
      evolutionTo: null,
      stage: 3,
    ),

    // ===== 소비 (money) =====
    Monster(
      id: 'money_001',
      name: '충동이',
      attribute: 'money',
      rarity: 'common',
      description: '"이건 사야 해"를 외치는 작은 악마',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'money', count: 1),
      evolutionTo: 'money_002',
      stage: 1,
    ),
    Monster(
      id: 'money_002',
      name: '과소비령',
      attribute: 'money',
      rarity: 'rare',
      description: '장바구니를 채우는 보이지 않는 손',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'money', count: 5),
      evolutionTo: 'money_003',
      stage: 2,
    ),
    Monster(
      id: 'money_003',
      name: '통장귀신',
      attribute: 'money',
      rarity: 'epic',
      description: '월급이 들어오면 순식간에 사라지게 만드는 존재',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'money', count: 15),
      evolutionTo: null,
      stage: 3,
    ),

    // ===== 생산성 (productivity) =====
    Monster(
      id: 'productivity_001',
      name: '폰좀비',
      attribute: 'productivity',
      rarity: 'common',
      description: '스마트폰에서 눈을 떼지 못하게 하는 존재',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'productivity', count: 1),
      evolutionTo: 'productivity_002',
      stage: 1,
    ),
    Monster(
      id: 'productivity_002',
      name: '미루기왕',
      attribute: 'productivity',
      rarity: 'rare',
      description: '"5분만 더..."를 1시간으로 만드는 마법사',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'productivity', count: 5),
      evolutionTo: 'productivity_003',
      stage: 2,
    ),
    Monster(
      id: 'productivity_003',
      name: '시간도둑',
      attribute: 'productivity',
      rarity: 'epic',
      description: '하루가 왜 이렇게 빨리 지나갔는지 모르게 만드는 원흉',
      imageUrl: '',
      unlockCondition: UnlockCondition(categoryKey: 'productivity', count: 15),
      evolutionTo: null,
      stage: 3,
    ),

    // ===== 희귀 몬스터 (시간대/요일 조건) =====

    // 심야 배달음식 괴물 (23시-2시)
    Monster(
      id: 'food_special_001',
      name: '심야 배달 고블린',
      attribute: 'food',
      rarity: 'rare',
      description: '새벽 배달음식의 유혹... 참을 수 있나요?',
      imageUrl: '',
      unlockCondition: UnlockCondition(
        categoryKey: 'food',
        count: 3,
        hourStart: 23,
        hourEnd: 2,
        bonusChance: 0.3, // 시간대 맞으면 +30%
      ),
      evolutionTo: null,
      stage: 1,
    ),

    // 금요일 폭식 드래곤
    Monster(
      id: 'food_special_002',
      name: '금요일 폭식 드래곤',
      attribute: 'food',
      rarity: 'epic',
      description: 'TGIF! 금요일 밤의 폭식을 주관하는 전설의 존재',
      imageUrl: '',
      unlockCondition: UnlockCondition(
        categoryKey: 'food',
        count: 5,
        dayOfWeek: 5, // 금요일
        bonusChance: 0.5, // 금요일이면 +50%
      ),
      evolutionTo: null,
      stage: 2,
    ),

    // 불면증 드래곤 (0시-4시)
    Monster(
      id: 'sleep_special_001',
      name: '불면증 드래곤',
      attribute: 'sleep',
      rarity: 'epic',
      description: '새벽 4시, 아직도 깨어있는 당신을 지배하는 자',
      imageUrl: '',
      unlockCondition: UnlockCondition(
        categoryKey: 'sleep',
        count: 5,
        hourStart: 0,
        hourEnd: 4,
        bonusChance: 0.4,
      ),
      evolutionTo: null,
      stage: 2,
    ),

    // 월요병 슬라임 (월요일)
    Monster(
      id: 'productivity_special_001',
      name: '월요병 슬라임',
      attribute: 'productivity',
      rarity: 'rare',
      description: '월요일 아침, 모든 의욕을 빨아먹는 존재',
      imageUrl: '',
      unlockCondition: UnlockCondition(
        categoryKey: 'productivity',
        count: 2,
        dayOfWeek: 1, // 월요일
        bonusChance: 0.6, // 월요일이면 +60%
      ),
      evolutionTo: null,
      stage: 1,
    ),

    // 주말 낭비왕 (토요일 or 일요일)
    Monster(
      id: 'productivity_special_002',
      name: '주말 낭비왕',
      attribute: 'productivity',
      rarity: 'epic',
      description: '주말을 침대에서 보내게 만드는 전설의 몬스터',
      imageUrl: '',
      unlockCondition: UnlockCondition(
        categoryKey: 'productivity',
        count: 3,
        dayOfWeek: 6, // 토요일 (일요일은 7)
        bonusChance: 0.5,
      ),
      evolutionTo: null,
      stage: 2,
    ),

    // 페이데이 악마 (전설)
    Monster(
      id: 'money_special_001',
      name: '페이데이 악마',
      attribute: 'money',
      rarity: 'legendary',
      description: '월급날, 통장을 텅 비게 만드는 전설 속의 존재',
      imageUrl: '',
      unlockCondition: UnlockCondition(
        categoryKey: 'money',
        count: 10,
        bonusChance: 0.0, // 전설이라 확률 낮음
      ),
      evolutionTo: null,
      stage: 3,
    ),
  ];

  /// ID로 몬스터 찾기
  static Monster? getById(String id) {
    try {
      return all.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 속성(카테고리)으로 몬스터 찾기
  static List<Monster> getByAttribute(String attribute) {
    return all.where((m) => m.attribute == attribute).toList();
  }

  /// 희귀도로 몬스터 찾기
  static List<Monster> getByRarity(String rarity) {
    return all.where((m) => m.rarity == rarity).toList();
  }
}
