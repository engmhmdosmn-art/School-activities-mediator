import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart' show PdfColor;
import 'package:provider/provider.dart';
import '../models/poster_template.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../services/pdf_service.dart';
import '../widgets/common_widgets.dart';

class PosterCustomizeScreen extends StatefulWidget {
  final PosterTemplate template;

  const PosterCustomizeScreen({super.key, required this.template});

  @override
  State<PosterCustomizeScreen> createState() => _PosterCustomizeScreenState();
}

class _PosterCustomizeScreenState extends State<PosterCustomizeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _schoolController;
  final _messageController = TextEditingController();
  PosterSize _size = PosterSize.a4;
  int _colorIndex = 0;
  Uint8List? _logoBytes;
  bool _generating = false;

  final List<Color> _themeColors = const [
    AppColors.primary,
    AppColors.secondary,
    AppColors.teal,
    AppColors.pink,
    Color(0xFF3E92CC),
  ];

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppState>().selectedProfile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _schoolController = TextEditingController(text: profile?.schoolName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => _logoBytes = bytes);
  }

  Color get _selectedColor => _themeColors[_colorIndex];

  Future<void> _generateAndPrint() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى إدخال الاسم أولًا')));
      return;
    }
    setState(() => _generating = true);
    try {
      final bytes = await PdfService.buildPoster(
        template: widget.template,
        size: _size,
        childName: _nameController.text.trim(),
        schoolName: _schoolController.text.trim(),
        customMessage: _messageController.text.trim(),
        themeColor: PdfColor.fromInt(_selectedColor.toARGB32()),
        logoBytes: _logoBytes,
      );
      await PdfService.printDocument(bytes, widget.template.title);
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.template.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
        children: [
          _LivePreview(
            title: widget.template.title,
            category: widget.template.category,
            name: _nameController.text,
            school: _schoolController.text,
            message: _messageController.text.isEmpty ? widget.template.description : _messageController.text,
            color: _selectedColor,
            logoBytes: _logoBytes,
          ),
          const SizedBox(height: 22),
          const Text('شعار المدرسة (اختياري)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _pickLogo,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Icon(_logoBytes == null ? Icons.upload_outlined : Icons.check_circle, color: AppColors.primary),
                  const SizedBox(height: 6),
                  Text(_logoBytes == null ? 'رفع شعار من المعرض' : 'تم رفع الشعار — اضغط للتغيير', style: const TextStyle(fontSize: 12.5)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'اسم الطالب'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _schoolController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'اسم المدرسة'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            onChanged: (_) => setState(() {}),
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'رسالة مخصصة (اختياري)'),
          ),
          const SizedBox(height: 18),
          const Text('لون التصميم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          Row(
            children: List.generate(_themeColors.length, (i) {
              final selected = _colorIndex == i;
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () => setState(() => _colorIndex = i),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _themeColors[i],
                      shape: BoxShape.circle,
                      border: selected ? Border.all(color: Colors.black87, width: 2.4) : null,
                    ),
                    child: selected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),
          const Text('حجم الطباعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          ...PosterSize.values.map(
            (s) => RadioListTile<PosterSize>(
              value: s,
              groupValue: _size,
              onChanged: (v) => setState(() => _size = v ?? _size),
              title: Text(s.label, style: const TextStyle(fontSize: 13.5)),
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
          const SizedBox(height: 20),
          GradientButton(
            label: 'توليد وطباعة',
            icon: Icons.auto_awesome,
            colors: const [AppColors.primary, AppColors.primaryDark],
            loading: _generating,
            onTap: _generateAndPrint,
          ),
        ],
      ),
    );
  }
}

class _LivePreview extends StatelessWidget {
  final String title;
  final String category;
  final String name;
  final String school;
  final String message;
  final Color color;
  final Uint8List? logoBytes;

  const _LivePreview({
    required this.title,
    required this.category,
    required this.name,
    required this.school,
    required this.message,
    required this.color,
    required this.logoBytes,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.75,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color, width: 6),
          gradient: LinearGradient(colors: [Colors.white, color.withValues(alpha: 0.06)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logoBytes != null) ...[
              ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.memory(logoBytes!, height: 56)),
              const SizedBox(height: 10),
            ],
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 14),
            Text('تُمنح هذه $category إلى', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(height: 6),
            Text(
              name.isEmpty ? 'اسم الطالب' : name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(school.isEmpty ? 'اسم المدرسة' : school, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: color.withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(10)),
              child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5)),
            ),
          ],
        ),
      ),
    );
  }
}
