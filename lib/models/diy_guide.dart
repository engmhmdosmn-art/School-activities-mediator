class DiyStep {
  final String title;
  final String description;

  const DiyStep({required this.title, required this.description});
}

class DiyGuide {
  final String id;
  final String title;
  final String category; // كرتون / إعادة تدوير / خيوط وصوف
  final String description;
  final String difficulty;
  final String timeEstimate;
  final int colorIndex;
  final List<String> materials;
  final List<DiyStep> steps;

  const DiyGuide({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.difficulty,
    required this.timeEstimate,
    required this.colorIndex,
    required this.materials,
    required this.steps,
  });
}
