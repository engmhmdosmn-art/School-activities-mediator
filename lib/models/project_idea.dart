import 'package:flutter/material.dart';

class ProjectIdea {
  final String id;
  final String title;
  final String subject;
  final IconData icon;
  final int colorIndex;
  final int minGrade;
  final int maxGrade;
  final String difficulty; // سهل / متوسط / صعب
  final String timeEstimate;
  final String description;
  final List<String> materials;
  final List<String> steps;
  final bool isPremium;

  const ProjectIdea({
    required this.id,
    required this.title,
    required this.subject,
    required this.icon,
    required this.colorIndex,
    required this.minGrade,
    required this.maxGrade,
    required this.difficulty,
    required this.timeEstimate,
    required this.description,
    required this.materials,
    required this.steps,
    this.isPremium = false,
  });
}
