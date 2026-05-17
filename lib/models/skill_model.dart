class SkillModel {
  final String name;
  final double level; // 0.0 to 1.0
  final String category;
  final String emoji;

  const SkillModel({
    required this.name,
    required this.level,
    required this.category,
    required this.emoji,
  });
}
