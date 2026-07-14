import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../utils/arabic_helpers.dart';
import '../widgets/common_widgets.dart';
import '../widgets/project_idea_card.dart';
import 'project_wizard_screen.dart';
import 'project_detail_screen.dart';

const Map<String, IconData> _subjectIcons = {
  'العلوم': Icons.science,
  'الرياضيات': Icons.calculate,
  'اللغة العربية': Icons.menu_book,
  'اللغة الإنجليزية': Icons.language,
  'التربية الإسلامية': Icons.mosque,
  'الدراسات الاجتماعية': Icons.public,
  'الفنون': Icons.palette,
};

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final subjects = MockData.subjects.where((s) => s != 'الكل').toList();

    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(milliseconds: 600)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _GreetingHeader(state: state),
          const SizedBox(height: 20),
          const SectionHeader(title: 'اختاري المادة الدراسية'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.92,
            children: subjects.map((s) {
              final idx = subjects.indexOf(s);
              final color = AppColors.palette[idx % AppColors.palette.length];
              return _SubjectTile(
                label: s,
                icon: _subjectIcons[s] ?? Icons.school,
                color: color,
                onTap: () {
                  state.setSubjectFilter(s);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProjectWizardScreen()));
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          FreemiumBanner(unlocked: state.isPremiumUnlocked, onTap: state.togglePremium),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'أفكار مميزة لهذا الأسبوع',
            actionText: 'عرض الكل',
            onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProjectWizardScreen())),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.featuredProjects.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final idea = state.featuredProjects[i];
                return SizedBox(
                  width: 165,
                  child: ProjectIdeaCard(
                    idea: idea,
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => ProjectDetailScreen(idea: idea))),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const AdBannerPlaceholder(),
        ],
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  final AppState state;
  const _GreetingHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final profile = state.selectedProfile;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('أهلاً بك 👋', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  profile != null ? 'مشاريع ${profile.name} اليوم' : 'أضيفي طفلك للبدء',
                  style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                ),
                if (profile != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${gradeLabel(profile.grade)} · ${profile.schoolName}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Text(
              profile != null && profile.name.isNotEmpty ? profile.name[0] : '🎒',
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SubjectTile({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
