import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Rounded gradient CTA button used across the 3-step journey.
class GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback? onTap;
  final bool loading;

  const GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: loading ? null : onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors, begin: Alignment.centerRight, end: Alignment.centerLeft),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: colors.first.withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                )
              else ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionText, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        if (actionText != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionText!, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFC93C), Color(0xFFFF8A3D)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.white, size: 12),
          SizedBox(width: 3),
          Text('مميز', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// Discreet, clearly-labelled ad placeholder for stationery advertisers.
class AdBannerPlaceholder extends StatelessWidget {
  const AdBannerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.3), style: BorderStyle.solid),
        color: AppColors.textMuted.withValues(alpha: 0.05),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer_outlined, color: AppColors.textMuted.withValues(alpha: 0.6), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'مساحة إعلانية · منتجات قرطاسية موصى بها',
              style: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.8), fontSize: 12.5),
            ),
          ),
          Text('إعلان', style: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.6), fontSize: 11)),
        ],
      ),
    );
  }
}

class FreemiumBanner extends StatelessWidget {
  final bool unlocked;
  final VoidCallback onTap;

  const FreemiumBanner({super.key, required this.unlocked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.pink]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.workspace_premium, color: Colors.white, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unlocked ? 'العضوية المميزة مُفعّلة ✨' : 'افتح كل القوالب المميزة',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    unlocked ? 'استمتعي بجميع الأفكار والقوالب دون قيود' : 'قوالب حصرية وأفكار إضافية لكل المواد',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(unlocked ? Icons.check_circle : Icons.chevron_left, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(icon, size: 56, color: AppColors.textMuted.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.8), fontSize: 14)),
        ],
      ),
    );
  }
}

class DifficultyTimeRow extends StatelessWidget {
  final String difficulty;
  final String time;

  const DifficultyTimeRow({super.key, required this.difficulty, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.bar_chart, size: 14, color: AppColors.textMuted.withValues(alpha: 0.7)),
        const SizedBox(width: 3),
        Text(difficulty, style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.9))),
        const SizedBox(width: 12),
        Icon(Icons.schedule, size: 14, color: AppColors.textMuted.withValues(alpha: 0.7)),
        const SizedBox(width: 3),
        Text(time, style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.9))),
      ],
    );
  }
}
