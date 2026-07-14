import 'dart:async';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/child_profile.dart';
import '../models/project_idea.dart';
import '../models/diy_guide.dart';
import '../models/order.dart';

/// Central application state. Acts as a mock local "database" — every
/// mutating call goes through a small artificial delay to emulate a real
/// async persistence / API layer, while everything is kept in memory.
class AppState extends ChangeNotifier {
  AppState() {
    // Seed with a couple of demo profiles so the app feels alive on first run.
    profiles.addAll([
      const ChildProfile(id: 'c1', name: 'ليان', grade: 3, schoolName: 'مدرسة الفرسان النموذجية', colorIndex: 2),
      const ChildProfile(id: 'c2', name: 'راشد', grade: 6, schoolName: 'مدرسة الفرسان النموذجية', colorIndex: 5),
    ]);
    selectedProfile = profiles.first;
    gradeFilter = selectedProfile!.grade;
  }

  // ----------------------------- Profiles -----------------------------
  final List<ChildProfile> profiles = [];
  ChildProfile? selectedProfile;

  void selectProfile(ChildProfile profile) {
    selectedProfile = profile;
    gradeFilter = profile.grade;
    notifyListeners();
  }

  Future<void> addProfile(ChildProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 400)); // mock write
    profiles.add(profile);
    selectedProfile ??= profile;
    notifyListeners();
  }

  Future<void> updateProfile(ChildProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = profiles.indexWhere((p) => p.id == profile.id);
    if (idx != -1) {
      profiles[idx] = profile;
      if (selectedProfile?.id == profile.id) selectedProfile = profile;
      notifyListeners();
    }
  }

  Future<void> deleteProfile(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    profiles.removeWhere((p) => p.id == id);
    if (selectedProfile?.id == id) {
      selectedProfile = profiles.isNotEmpty ? profiles.first : null;
    }
    notifyListeners();
  }

  // ------------------------- Project idea bank -------------------------
  final List<ProjectIdea> allProjects = MockData.projects;

  String subjectFilter = 'الكل';
  int? gradeFilter;

  void setSubjectFilter(String subject) {
    subjectFilter = subject;
    notifyListeners();
  }

  void setGradeFilter(int? grade) {
    gradeFilter = grade;
    notifyListeners();
  }

  List<ProjectIdea> get filteredProjects {
    return allProjects.where((p) {
      final subjectOk = subjectFilter == 'الكل' || p.subject == subjectFilter;
      final gradeOk = gradeFilter == null || (gradeFilter! >= p.minGrade && gradeFilter! <= p.maxGrade);
      return subjectOk && gradeOk;
    }).toList();
  }

  List<ProjectIdea> get featuredProjects => allProjects.take(5).toList();

  // ------------------------------ Posters ------------------------------
  final posterTemplates = MockData.posterTemplates;
  String posterCategoryFilter = 'الكل';

  void setPosterCategoryFilter(String category) {
    posterCategoryFilter = category;
    notifyListeners();
  }

  // ------------------------------ DIY guides ------------------------------
  final diyGuides = MockData.diyGuides;
  String diyCategoryFilter = 'الكل';

  void setDiyCategoryFilter(String category) {
    diyCategoryFilter = category;
    notifyListeners();
  }

  List<DiyGuide> get filteredDiyGuides =>
      diyGuides.where((g) => diyCategoryFilter == 'الكل' || g.category == diyCategoryFilter).toList();

  // ------------------------------ Premium ------------------------------
  bool isPremiumUnlocked = false;

  void togglePremium() {
    isPremiumUnlocked = !isPremiumUnlocked;
    notifyListeners();
  }

  // ------------------------------ Orders ------------------------------
  final List<Order> orders = [];
  final Map<String, List<Timer>> _trackingTimers = {};

  Future<Order> placeOrder({
    required OrderType type,
    required String itemTitle,
    required double price,
    int quantity = 1,
    String? address,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700)); // mock API call
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      itemTitle: itemTitle,
      date: DateTime.now(),
      price: price * quantity,
      quantity: quantity,
      status: type == OrderType.homePrint ? OrderStatus.delivered : OrderStatus.pending,
      address: address,
    );
    orders.insert(0, order);
    notifyListeners();

    if (type == OrderType.printOnDemand) {
      _simulateTracking(order.id);
    }
    return order;
  }

  /// Simulates a live-updating delivery tracker for print-on-demand orders.
  void _simulateTracking(String orderId) {
    final stages = [
      OrderStatus.confirmed,
      OrderStatus.printing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];
    final timers = <Timer>[];
    for (var i = 0; i < stages.length; i++) {
      final timer = Timer(Duration(seconds: 4 * (i + 1)), () {
        final idx = orders.indexWhere((o) => o.id == orderId);
        if (idx == -1) return;
        orders[idx] = orders[idx].copyWith(status: stages[i]);
        notifyListeners();
      });
      timers.add(timer);
    }
    _trackingTimers[orderId] = timers;
  }

  @override
  void dispose() {
    for (final list in _trackingTimers.values) {
      for (final t in list) {
        t.cancel();
      }
    }
    super.dispose();
  }
}
