import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'diy_guide_detail_screen.dart';

const Map<String, IconData> _categoryIcons = {
  'كرتون': Icons.inventory_2_outlined,
  'إعادة تدوير': Icons.recycling,
  'خيوط وصوف': Icons.blur_circular,
};

class DiyGuideScreen extends StatelessWidget {
  const DiyGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final guides = state.filteredDiyGuides;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ركن الأشغال اليدوية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'أدلة مصورة خطوة بخطوة للكرتون وإعادة التدوير والخيوط',
                style: TextStyle(fontSize: 12.5, color: AppColors.textMuted.withValues(alpha: 0.9)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.diyCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final c = MockData.diyCategories[i];
                    final selected = state.diyCategoryFilter == c;
                    return ChoiceChip(
                      label: Text(c),
                      selected: selected,
                      onSelected: (_) => state.setDiyCategoryFilter(c),
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
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: guides.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final g = guides[i];
              final color = AppColors.palette[g.colorIndex % AppColors.palette.length];
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DiyGuideDetailScreen(guide: g))),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
                        child: Icon(_categoryIcons[g.category] ?? Icons.handyman, color: color, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(g.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                            const SizedBox(height: 4),
                            Text(
                              g.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11.5, color: AppColors.textMuted.withValues(alpha: 0.9)),
                            ),
                            const SizedBox(height: 6),
                            DifficultyTimeRow(difficulty: g.difficulty, time: g.timeEstimate),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_left, color: AppColors.textMuted),
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
