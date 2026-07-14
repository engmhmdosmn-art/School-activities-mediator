import 'package:flutter/material.dart';
import '../models/child_profile.dart';
import '../theme/app_theme.dart';
import '../utils/arabic_helpers.dart';

class ChildAvatarCard extends StatelessWidget {
  final ChildProfile profile;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ChildAvatarCard({
    super.key,
    required this.profile,
    required this.selected,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.palette[profile.colorIndex % AppColors.palette.length];
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : Colors.transparent, width: 2.2),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Text(
                profile.name.isNotEmpty ? profile.name[0] : '؟',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(
                    '${gradeLabel(profile.grade)} · ${profile.schoolName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.9), fontSize: 12.5),
                  ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle, color: color, size: 22),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
