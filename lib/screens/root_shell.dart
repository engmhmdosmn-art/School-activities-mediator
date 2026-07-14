import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'project_wizard_screen.dart';
import 'visual_matcher_screen.dart';
import 'diy_guide_screen.dart';
import 'profiles_screen.dart';
import 'orders_list_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _titles = ['الوسيط المدرسي', 'بنك الأفكار', 'المطابقة البصرية', 'الأشغال اليدوية', 'ملفاتي'];

  final _screens = const [
    HomeScreen(),
    ProjectWizardScreen(),
    VisualMatcherScreen(),
    DiyGuideScreen(),
    ProfilesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'طلباتي',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrdersListScreen())),
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_rounded), label: 'الأفكار'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_rounded), label: 'المطابقة'),
          BottomNavigationBarItem(icon: Icon(Icons.handyman_rounded), label: 'الأشغال'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_rounded), label: 'ملفاتي'),
        ],
      ),
    );
  }
}
