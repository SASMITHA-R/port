class ProjectModel {
  final String title;
  final String description;
  final List<String> techStack;
  final String? githubUrl;
  final String? liveUrl;
  final String emoji;
  final String gradientStart;
  final String gradientEnd;
  final bool isBiDashboard;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.techStack,
    this.githubUrl,
    this.liveUrl,
    required this.emoji,
    required this.gradientStart,
    required this.gradientEnd,
    this.isBiDashboard = false,
  });
}
