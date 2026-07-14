import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_idea.dart';
import '../models/order.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/material_checklist.dart';
import 'checkout_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectIdea idea;

  const ProjectDetailScreen({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final color = AppColors.palette[idea.colorIndex % AppColors.palette.length];
    final locked = idea.isPremium && !state.isPremiumUnlocked;

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المشروع')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 110),
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
                child: Icon(idea.icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(idea.title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, height: 1.3)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                          child: Text(idea.subject, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        if (idea.isPremium) const PremiumBadge(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          DifficultyTimeRow(difficulty: idea.difficulty, time: idea.timeEstimate),
          const SizedBox(height: 18),
          if (locked)
            _LockedBanner(onUnlock: state.togglePremium)
          else ...[
            Text(idea.description, style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textDark.withValues(alpha: 0.9))),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
              child: MaterialChecklist(materials: idea.materials),
            ),
            const SizedBox(height: 22),
            const Text('خطوات التنفيذ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            ...List.generate(idea.steps.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(idea.steps[i], style: const TextStyle(fontSize: 13.5, height: 1.5))),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
      bottomNavigationBar: locked
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        label: 'طباعة منزلية',
                        icon: Icons.print_outlined,
                        colors: const [AppColors.teal, Color(0xFF0FA595)],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(orderType: OrderType.homePrint, projectIdea: idea),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GradientButton(
                        label: 'اطلب من المطبعة',
                        icon: Icons.local_shipping_outlined,
                        colors: const [AppColors.secondary, Color(0xFFE8621F)],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(orderType: OrderType.printOnDemand, projectIdea: idea),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _LockedBanner extends StatelessWidget {
  final VoidCallback onUnlock;
  const _LockedBanner({required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.pink]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.lock_outline, color: Colors.white, size: 34),
          const SizedBox(height: 10),
          const Text(
            'هذا المشروع من المحتوى المميز',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'افتحي العضوية المميزة للوصول إلى قائمة المواد وخطوات التنفيذ الكاملة.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onUnlock,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
            child: const Text('فتح المحتوى المميز (تجريبي)'),
          ),
        ],
      ),
    );
  }
}
