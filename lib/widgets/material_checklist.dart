import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MaterialChecklist extends StatefulWidget {
  final List<String> materials;

  const MaterialChecklist({super.key, required this.materials});

  @override
  State<MaterialChecklist> createState() => _MaterialChecklistState();
}

class _MaterialChecklistState extends State<MaterialChecklist> {
  late List<bool> _checked = List.filled(widget.materials.length, false);

  int get _completedCount => _checked.where((c) => c).length;

  @override
  Widget build(BuildContext context) {
    final progress = widget.materials.isEmpty ? 0.0 : _completedCount / widget.materials.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('قائمة المواد المطلوبة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text(
              '$_completedCount من ${widget.materials.length} جاهزة',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.9)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation(AppColors.success),
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(widget.materials.length, (i) {
          return CheckboxListTile(
            value: _checked[i],
            onChanged: (v) => setState(() => _checked[i] = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
            activeColor: AppColors.success,
            title: Text(
              widget.materials[i],
              style: TextStyle(
                fontSize: 14,
                decoration: _checked[i] ? TextDecoration.lineThrough : null,
                color: _checked[i] ? AppColors.textMuted : AppColors.textDark,
              ),
            ),
          );
        }),
      ],
    );
  }
}
