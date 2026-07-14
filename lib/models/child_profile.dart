class ChildProfile {
  final String id;
  final String name;
  final int grade; // 1-12
  final String schoolName;
  final int colorIndex; // index into AppTheme.avatarColors

  const ChildProfile({
    required this.id,
    required this.name,
    required this.grade,
    required this.schoolName,
    required this.colorIndex,
  });

  ChildProfile copyWith({
    String? name,
    int? grade,
    String? schoolName,
    int? colorIndex,
  }) {
    return ChildProfile(
      id: id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      schoolName: schoolName ?? this.schoolName,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}
