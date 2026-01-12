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
      description: '배달앱을 켜는 순간 어디선가 나타나는 작은 존재. '
          '통통한 몸에 큰 입을 가진 귀여운 생명체로, 항상 배고픈 표정을 짓고 있다. '
          '당신의 첫 번째 야식 욕구가 형상화되어 태어난 동료. '
          '"주인님, 저도 배고파요..." 라며 졸졸 따라다닌다. '
          '완벽한 다이어트는 없다. 가끔 실수해도 괜찮다.',
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
      description: '새벽 2시, 배달앱을 여는 자의 그림자가 실체화된 모습. '
          '반투명한 몸에서 은은한 빛이 나며, 손에는 항상 스마트폰을 들고 있다. '
          '야식이가 성장하면서 밤의 유혹에 더 익숙해진 형태. '
          '주변에는 치킨과 피자 조각들이 떠다닌다. '
          '"오늘만... 내일부터 조절하면 되죠?" 라는 속삭임이 들린다. '
          '솔직한 것도 용기다.',
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
      description: '냉장고 문을 열면 항상 그가 있다. 거대한 몸집에 음식 왕관을 쓴 최종 형태. '
          '배가 냉장고처럼 생겼으며, 여러 개의 팔로 동시에 먹는 것이 가능하다. '
          '야식 문화의 정점에 도달한 존재로, 이미 죄책감 따윈 초월했다. '
          '"주인님 덕분에 매일 건강해요!" 라며 만족스러운 미소를 짓는다. '
          '인정하는 게 첫걸음. 당신은 이미 충분히 솔직하다.',
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
      description: '알람을 끄는 손가락에 붙어있는 작은 구름 같은 존재. '
          '항상 눈을 감고 있으며, 머리에는 알람시계 장식이 달려있다. '
          '몸 주변에 작은 \'Z\' 표시가 떠다니는 것이 특징. '
          '"5분만 더... 딱 5분만..." 이라는 당신의 마음이 형상화된 동료. '
          '아침은 모두에게 어렵다. 당신만 그런 게 아니다.',
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
      description: '밤이 깊어질수록 강해지는 보라빛 유령. '
          '피곤한 눈 밑 다크서클이 인상적이며, 손에는 스마트폰을 들고 있다. '
          '몸에서 블루라이트가 빛나며, 밤하늘의 별과 달 패턴이 새겨져 있다. '
          '"자야 하는데... 근데 딱 이것만 보고..." 라는 무한 루프의 화신. '
          '완벽한 수면 패턴은 신화다. 가끔은 밤샘도 인생이다.',
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
      description: '거대한 악마 형태로 진화한 불면의 화신. '
          '머리에 알람시계 모양의 뿔이 있으며, 날개는 너무 피곤해서 제대로 펼치지 못한다. '
          '몸에 커피잔과 에너지드링크 문양이 새겨져 있고, 주변에는 카페인 오라가 감돈다. '
          '"잠은 죽어서 자라"는 말을 실천하는 존재. 하지만 눈빛은 여전히 따뜻하다. '
          '당신은 각성했다. 좀비처럼 보여도, 살아있다는 증거다.',
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
      description: '소파에서 일어나지 못하게 하는 작은 애벌레 같은 생명체. '
          '배를 땅에 붙이고 누워있으며, 짧고 무기력한 팔다리를 가지고 있다. '
          '머리에는 소파 쿠션 모양의 모자를 쓰고, 몸에는 "내일부터" 라는 글자가 새겨져 있다. '
          '"오늘은 날씨가 안 좋아서..." 라는 핑계의 화신. '
          '완벽한 운동 루틴은 환상이다. 쉬는 것도 필요하다.',
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
      description: '나무늘보 같은 형태로 진화한 게으름의 화신. '
          '소파에 완전히 녹아붙어 있으며, 한 손에는 리모컨을, 다른 손에는 과자봉지를 들고 있다. '
          '몸 주변에는 먼지가 쌓여있고, 표정은 극도로 평화롭다. '
          '"내일부터 운동해야지"를 매일 말하는 존재. 하지만 눈빛만은 진지하다. '
          '때로는 쉬는 것이 최고의 운동이다. 정말이다.',
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
      description: '소파와 완전히 융합된 거대한 생명체. 이제 몸이 소파 자체가 되었다. '
          '여러 개의 팔로 동시에 게임, 먹방, 넷플릭스를 즐긴다. '
          '주변에는 화석화된 헬스장 회원권과 운동복이 전시되어 있다. '
          '게으름 오라를 뿜어내며 다른 몬스터들까지 졸게 만드는 능력 보유. '
          '"주인님도 이제 편안해지셨나요?" 만족스러운 미소를 짓는다. 당신은 정직하다.',
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
      description: '동전 모양의 귀여운 생명체. 큰 눈이 반짝반짝 빛난다. '
          '작은 날개를 달고 있어 천사 같지만 실은 작은 악마. '
          '손에 카드를 들고 있으며, "이건 사야 해!" 라는 말풍선이 항상 떠있다. '
          '"할인이래요! 지금 안 사면 손해예요!" 라며 속삭인다. '
          '충동구매도 때로는 행복이다. 스스로를 위한 작은 선물.',
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
      description: '쇼핑백을 뒤집어쓴 유령 형태로 진화했다. '
          '몸 주변에 쇼핑백과 택배 상자가 떠다니며, 손에서는 카드 광선이 나온다. '
          '머리에는 빨간 "Sale" 표시가 빛나고, 주변에는 영수증이 흩날린다. '
          '"어머 이건 사야 해" 를 외치며 장바구니를 채우는 보이지 않는 손. '
          '소비도 경제 활동이다. 당신은 경제를 돌리고 있다.',
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
      description: '거대한 악마로 진화한 소비의 화신. 몸이 텅 빈 지갑 모양을 하고 있다. '
          '여러 개의 손으로 동시에 쇼핑하며, 머리에는 카드, 현금, 계좌이체 왕관을 쓰고 있다. '
          '주변에는 "-10,000원", "-50,000원" 같은 마이너스 이펙트가 떠다닌다. '
          '월급이 들어오는 순간 순식간에 사라지게 만드는 마법 보유. '
          '"주인님은 돈 쓰는 맛을 아시는군요" 사악하지만 따뜻한 미소. 당신은 인간답다.',
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
      description: '작은 좀비 형태의 생명체. 고개를 폰 쪽으로 숙이고 있다. '
          '눈에서 블루라이트가 나오며, 한 손은 끊임없이 스크롤 동작을 한다. '
          '발이 땅에서 살짝 떠있는 것은 집중의 증거. '
          '"딱 이것만 보고... 아, 또 뭐가 떴네..." 무한 루프의 시작. '
          '디지털 세상도 현실이다. 당신은 연결되어 있다.',
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
      description: '왕좌에 앉은 당당한 모습으로 진화했다. '
          '한 손에는 "5분만 더" 깃발을, 다른 손에는 시간이 왜곡된 시계를 들고 있다. '
          '주변에는 미완성 작업물들이 쌓여있고, 왕관에는 "내일부터" 문구가 새겨져 있다. '
          '"5분만 더..."를 1시간으로 만드는 마법사. 표정은 여유롭다. '
          '완벽한 타이밍은 없다. 지금이 아니어도 괜찮다.',
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
      description: '거대한 도둑 형태로 진화한 시간의 지배자. '
          '망토 안에는 수많은 시계들이 가득하고, 몸체는 모래시계처럼 생겼다. '
          '손에서는 시간을 빨아들이는 검은 구멍이 생성되며, "하루가 어떻게 갔지?" 오라를 뿜는다. '
          '아침에 눈 뜨면 어느새 밤. 하루가 왜 이렇게 빨리 지나가는지의 정체. '
          '"시간은 환상이에요" 신비로운 미소. 당신은 시간을 즐기고 있다.',
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
      description: '밤 11시부터 새벽 2시, 어둠 속에서만 나타나는 전설의 배달원. '
          '고블린 형태에 배달 가방을 메고 있으며, 한 손에는 치킨 상자를, 다른 손에는 배달앱을 든 모습. '
          '시계가 정확히 23:00-02:00을 가리킬 때만 습관 차원에 출몰한다. '
          '달빛 아래 실루엣만 보이며, "배고프시죠? 제가 다 알아요..." 라고 속삭인다. '
          '새벽 배달의 유혹은 강력하다. 참을 수 있나요? 참지 않아도 괜찮아요.',
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
      description: 'TGIF! 금요일에만 깨어나는 전설의 드래곤. '
          '작은 몸집이지만 당당하며, 날개에는 "TGIF" 문구가 새겨져 있다. '
          '입에서는 치맥 브레스를 뿜어내고, 꼬리는 소주병 모양으로 변형되었다. '
          '금요일 밤의 폭식을 주관하는 존재로, 주변에는 끊임없이 축제 파티클이 떠다닌다. '
          '"일주일 고생했는데 이 정도는 괜찮죠!" 금요일의 해방감을 상징한다. '
          '금요일은 특별하다. 당신도 특별하다.',
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
      description: '자정부터 새벽 4시, 가장 깊은 어둠 속에서만 나타나는 거대한 드래곤. '
          '침대에 누워 있지만 눈은 크게 뜨고 있으며, 날개는 이불처럼 몸을 덮고 있다. '
          '주변에는 떠다니는 걱정거리들과 밤하늘의 별 파티클이 함께한다. '
          '시계가 00:00-04:00을 가리킬 때만 습관 차원에 모습을 드러낸다. '
          '"새벽 4시, 아직도 깨어있는 당신... 당신은 외롭지 않습니다" '
          '밤을 지새우는 사람들의 수호자. 당신은 혼자가 아니다.',
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
      description: '월요일에만 나타나는 우울한 슬라임. '
          '몸이 완전히 축 늘어져 녹아내리는 형태를 하고 있으며, 우울한 블루와 그레이 색상. '
          '"월요일..." 이라는 말풍선이 항상 떠있고, 출근 가방을 질질 끌고 다닌다. '
          '월요일 아침의 모든 의욕을 빨아먹는 존재. 주변에는 우울 파티클이 위로 느리게 떠오른다. '
          '"다 같이 힘든 거예요" 라고 위로한다. '
          '월요일은 누구에게나 어렵다. 당신만 그런 게 아니다.',
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
      description: '토요일에만 깨어나는 전설의 왕. 침대가 곧 왕좌다. '
          '침대와 융합된 형태로, 머리에는 토요일과 일요일이 새겨진 주말 왕관을 쓰고 있다. '
          '온몸이 잠옷으로 감싸여 있으며, 주변에는 허비된 시간의 유령들이 떠다닌다. '
          '주말을 침대에서 보내게 만드는 강력한 마법 보유. 시간이 녹아내리는 듯한 이펙트. '
          '"주말은 쉬는 날이에요. 아무것도 안 해도 괜찮아요" '
          '당신은 휴식의 소중함을 안다.',
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
      description: '월급날에만 나타나는 전설 속의 악마. 만나기 극히 어렵다. '
          '거대한 악마 날개를 가지고 있으며, 몸 전체가 돈으로 만들어져 있다. '
          '뿔에서는 카드 광선이 나오고, 주변에는 "-월급" 이펙트가 떠다닌다. '
          '금화가 비처럼 떨어지는 파티클이 끊임없이 생성되며, 배경이 일시적으로 금빛으로 변한다. '
          '"월급이 들어오는 순간, 나는 깨어난다. 나는 당신의 자유다" '
          '등장 시 경고음과 함께 화면 전체가 빛난다. '
          '돈 쓰는 것도 능력이다. 당신은 경제를 움직인다.',
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
