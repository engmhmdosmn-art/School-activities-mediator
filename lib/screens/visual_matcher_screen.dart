import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'poster_customize_screen.dart';

class VisualMatcherScreen extends StatelessWidget {
  const VisualMatcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final categories = ['الكل', ...{for (final t in state.posterTemplates) t.category}];
    final templates = state.posterTemplates
        .where((t) => state.posterCategoryFilter == 'الكل' || t.category == state.posterCategoryFilter)
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('المطابقة البصرية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'قوالب شهادات، أوسمة، وملصقات جاهزة للتخصيص والطباعة',
                style: TextStyle(fontSize: 12.5, color: AppColors.textMuted.withValues(alpha: 0.9)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final c = categories[i];
                    final selected = state.posterCategoryFilter == c;
                    return ChoiceChip(
                      label: Text(c),
                      selected: selected,
                      onSelected: (_) => state.setPosterCategoryFilter(c),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w600),
                      backgroundColor: AppColors.surface,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 18),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: templates.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, i) {
              final t = templates[i];
              final color = AppColors.palette[t.colorIndex % AppColors.palette.length];
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PosterCustomizeScreen(template: t))),
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
                            child: Icon(t.icon, color: color, size: 22),
                          ),
                          const Spacer(),
                          if (t.isPremium) const PremiumBadge(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(t.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        t.category,
                        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        t.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
