import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../utils/arabic_helpers.dart';
import '../widgets/common_widgets.dart';
import '../widgets/project_idea_card.dart';
import 'project_detail_screen.dart';

class ProjectWizardScreen extends StatelessWidget {
  const ProjectWizardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final ideas = state.filteredProjects;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('بنك الأفكار المخصصة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'اختاري مادة وصفًا دراسيًا لعرض الأفكار المناسبة',
                style: TextStyle(fontSize: 12.5, color: AppColors.textMuted.withValues(alpha: 0.9)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.subjects.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final s = MockData.subjects[i];
                    final selected = state.subjectFilter == s;
                    return ChoiceChip(
                      label: Text(s),
                      selected: selected,
                      onSelected: (_) => state.setSubjectFilter(s),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w600),
                      backgroundColor: AppColors.surface,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.school_outlined, size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: state.gradeFilter,
                        isExpanded: true,
                        hint: const Text('كل الصفوف'),
                        items: [
                          const DropdownMenuItem<int?>(value: null, child: Text('كل الصفوف')),
                          ...allGrades.map((g) => DropdownMenuItem<int?>(value: g, child: Text(gradeLabel(g)))),
                        ],
                        onChanged: state.setGradeFilter,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ideas.isEmpty
              ? const EmptyState(icon: Icons.search_off, message: 'لا توجد أفكار مطابقة لهذا الفلتر حاليًا')
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                  itemCount: ideas.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, i) {
                    final idea = ideas[i];
                    return ProjectIdeaCard(
                      idea: idea,
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => ProjectDetailScreen(idea: idea))),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
