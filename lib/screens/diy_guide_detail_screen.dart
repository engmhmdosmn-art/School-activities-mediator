import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../models/diy_guide.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/diy_stepper.dart';

class DiyGuideDetailScreen extends StatefulWidget {
  final DiyGuide guide;

  const DiyGuideDetailScreen({super.key, required this.guide});

  @override
  State<DiyGuideDetailScreen> createState() => _DiyGuideDetailScreenState();
}

class _DiyGuideDetailScreenState extends State<DiyGuideDetailScreen> {
  late List<bool> _completedSteps = List.filled(widget.guide.steps.length, false);
  late final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  bool _celebrated = false;

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _toggleStep(int index) {
    setState(() => _completedSteps[index] = !_completedSteps[index]);
    if (_completedSteps.every((c) => c) && !_celebrated) {
      _celebrated = true;
      _confettiController.play();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 عمل رائع! تم إكمال المشروع بنجاح'), backgroundColor: AppColors.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.guide;
    final color = AppColors.palette[g.colorIndex % AppColors.palette.length];

    return Scaffold(
      appBar: AppBar(title: const Text('دليل الأشغال اليدوية')),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
                    child: Icon(Icons.handyman, color: color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(g.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        DifficultyTimeRow(difficulty: g.difficulty, time: g.timeEstimate),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(g.description, style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textDark.withValues(alpha: 0.9))),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('المواد المطلوبة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    ...g.materials.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Icon(Icons.circle, size: 6, color: color),
                              const SizedBox(width: 8),
                              Expanded(child: Text(m, style: const TextStyle(fontSize: 13))),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text('خطوات التنفيذ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(
                'اضغط على كل رقم عند إتمام الخطوة',
                style: TextStyle(fontSize: 11.5, color: AppColors.textMuted.withValues(alpha: 0.8)),
              ),
              const SizedBox(height: 14),
              DiyStepperWidget(steps: g.steps, completed: _completedSteps, onToggle: _toggleStep),
            ],
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2,
            maxBlastForce: 20,
            minBlastForce: 8,
            emissionFrequency: 0.04,
            numberOfParticles: 24,
            gravity: 0.25,
            colors: const [AppColors.primary, AppColors.secondary, AppColors.teal, AppColors.pink, AppColors.yellow],
          ),
        ],
      ),
    );
  }
}
