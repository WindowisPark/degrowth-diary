/// 카테고리 키 상수
enum CategoryKey {
  food('food', '식습관', '🍖'),
  sleep('sleep', '수면', '😴'),
  exercise('exercise', '운동/건강', '🏃'),
  money('money', '돈', '💸'),
  productivity('productivity', '생산성', '📱'),
  relationship('relationship', '관계', '👥'),
  habit('habit', '습관', '🍺'),
  other('other', '기타', '❓');

  const CategoryKey(this.key, this.label, this.emoji);

  final String key;
  final String label;
  final String emoji;

  static CategoryKey? fromKey(String key) {
    return CategoryKey.values.where((e) => e.key == key).firstOrNull;
  }
}

/// 소분류 키 상수
enum SubCategoryKey {
  // food
  lateNight('late_night', '야식', CategoryKey.food),
  binge('binge', '폭식', CategoryKey.food),
  delivery('delivery', '배달', CategoryKey.food),
  overeat('overeat', '과식', CategoryKey.food),

  // sleep
  oversleep('oversleep', '늦잠', CategoryKey.sleep),
  allNighter('all_nighter', '밤샘', CategoryKey.sleep),
  excessiveNap('excessive_nap', '낮잠과다', CategoryKey.sleep),

  // exercise
  skipWorkout('skip_workout', '운동 스킵', CategoryKey.exercise),
  skipStairs('skip_stairs', '계단 안 감', CategoryKey.exercise),

  // money
  impulseBuy('impulse_buy', '충동구매', CategoryKey.money),
  overspend('overspend', '과소비', CategoryKey.money),
  gacha('gacha', '현질', CategoryKey.money),

  // productivity
  procrastinate('procrastinate', '미루기', CategoryKey.productivity),
  snsOveruse('sns_overuse', 'SNS 과몰입', CategoryKey.productivity),
  youtube('youtube', '유튜브', CategoryKey.productivity),

  // relationship
  ghost('ghost', '읽씹', CategoryKey.relationship),
  flake('flake', '약속 펑크', CategoryKey.relationship),

  // habit
  alcohol('alcohol', '음주', CategoryKey.habit),
  smoking('smoking', '흡연', CategoryKey.habit),
  caffeine('caffeine', '카페인', CategoryKey.habit),

  // other
  custom('custom', '직접 입력', CategoryKey.other);

  const SubCategoryKey(this.key, this.label, this.category);

  final String key;
  final String label;
  final CategoryKey category;

  static SubCategoryKey? fromKey(String key) {
    return SubCategoryKey.values.where((e) => e.key == key).firstOrNull;
  }

  static List<SubCategoryKey> byCategory(CategoryKey category) {
    return SubCategoryKey.values.where((e) => e.category == category).toList();
  }
}
