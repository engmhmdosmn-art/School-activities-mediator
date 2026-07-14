import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/child_profile.dart';
import '../theme/app_theme.dart';
import '../utils/arabic_helpers.dart';
import '../widgets/child_avatar_card.dart';
import '../widgets/common_widgets.dart';

class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => _openProfileSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('إضافة طفل'),
      ),
      body: state.profiles.isEmpty
          ? const EmptyState(icon: Icons.family_restroom, message: 'لم تتم إضافة أي ملف طفل بعد')
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              itemCount: state.profiles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final p = state.profiles[i];
                return ChildAvatarCard(
                  profile: p,
                  selected: state.selectedProfile?.id == p.id,
                  onTap: () => state.selectProfile(p),
                  onDelete: () => _confirmDelete(context, p),
                );
              },
            ),
    );
  }

  void _confirmDelete(BuildContext context, ChildProfile profile) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('حذف الملف؟'),
        content: Text('سيتم حذف ملف "${profile.name}" نهائيًا.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              context.read<AppState>().deleteProfile(profile.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('حذف', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _openProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddProfileSheet(),
    );
  }
}

class _AddProfileSheet extends StatefulWidget {
  const _AddProfileSheet();

  @override
  State<_AddProfileSheet> createState() => _AddProfileSheetState();
}

class _AddProfileSheetState extends State<_AddProfileSheet> {
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  int _grade = 3;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty || _schoolController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى تعبئة الاسم واسم المدرسة')));
      return;
    }
    setState(() => _saving = true);
    final state = context.read<AppState>();
    await state.addProfile(
      ChildProfile(
        id: 'c${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        grade: _grade,
        schoolName: _schoolController.text.trim(),
        colorIndex: state.profiles.length,
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 18),
            const Text('إضافة ملف طفل جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'اسم الطفل')),
            const SizedBox(height: 14),
            DropdownButtonFormField<int>(
              value: _grade,
              decoration: const InputDecoration(labelText: 'الصف الدراسي'),
              items: allGrades.map((g) => DropdownMenuItem(value: g, child: Text(gradeLabel(g)))).toList(),
              onChanged: (v) => setState(() => _grade = v ?? _grade),
            ),
            const SizedBox(height: 14),
            TextField(controller: _schoolController, decoration: const InputDecoration(labelText: 'اسم المدرسة')),
            const SizedBox(height: 22),
            GradientButton(
              label: 'حفظ الملف',
              icon: Icons.check_circle_outline,
              colors: const [AppColors.primary, AppColors.primaryDark],
              loading: _saving,
              onTap: _save,
            ),
          ],
        ),
      ),
    );
  }
}
