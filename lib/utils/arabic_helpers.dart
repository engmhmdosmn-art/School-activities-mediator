// Small helpers for Arabic display strings used across the app.

const List<String> _ordinals = [
  'الأول',
  'الثاني',
  'الثالث',
  'الرابع',
  'الخامس',
  'السادس',
  'السابع',
  'الثامن',
  'التاسع',
  'العاشر',
  'الحادي عشر',
  'الثاني عشر',
];

/// Converts a numeric grade (1-12) into a readable Arabic school grade label.
String gradeLabel(int grade) {
  if (grade < 1 || grade > 12) return 'غير محدد';
  return 'الصف ${_ordinals[grade - 1]}';
}

final List<int> allGrades = List.generate(12, (i) => i + 1);

String formatArabicDate(DateTime date) {
  const months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String formatArabicTime(DateTime date) {
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour >= 12 ? 'م' : 'ص';
  return '$hour:$minute $period';
}
