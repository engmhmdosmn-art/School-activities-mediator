import 'package:flutter/material.dart';
import '../models/project_idea.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

class ProjectIdeaCard extends StatelessWidget {
  final ProjectIdea idea;
  final VoidCallback onTap;

  const ProjectIdeaCard({super.key, required this.idea, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.palette[idea.colorIndex % AppColors.palette.length];
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 5))],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
                  child: Icon(idea.icon, color: color, size: 22),
                ),
                const Spacer(),
                if (idea.isPremium) const PremiumBadge(),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              idea.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, height: 1.3),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(idea.subject, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            DifficultyTimeRow(difficulty: idea.difficulty, time: idea.timeEstimate),
          ],
        ),
      ),
    );
  }
}
