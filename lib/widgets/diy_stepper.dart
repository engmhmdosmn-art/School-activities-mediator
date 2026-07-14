import 'package:flutter/material.dart';
import '../models/diy_guide.dart';
import '../theme/app_theme.dart';

class DiyStepperWidget extends StatelessWidget {
  final List<DiyStep> steps;
  final List<bool> completed;
  final ValueChanged<int> onToggle;

  const DiyStepperWidget({
    super.key,
    required this.steps,
    required this.completed,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final isLast = i == steps.length - 1;
        final done = completed[i];
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () => onToggle(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? AppColors.success : AppColors.primary.withValues(alpha: 0.12),
                        border: Border.all(color: done ? AppColors.success : AppColors.primary, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: done
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : Text(
                              '${i + 1}',
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2.4,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        color: done ? AppColors.success.withValues(alpha: 0.5) : AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 22, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          decoration: done ? TextDecoration.lineThrough : null,
                          color: done ? AppColors.textMuted : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        steps[i].description,
                        style: TextStyle(fontSize: 13.5, color: AppColors.textMuted.withValues(alpha: 0.9), height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
