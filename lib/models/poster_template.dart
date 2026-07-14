import 'package:flutter/material.dart';

enum PosterSize { a4, a3, wallPoster }

extension PosterSizeLabel on PosterSize {
  String get label {
    switch (this) {
      case PosterSize.a4:
        return 'A4 (طباعة منزلية)';
      case PosterSize.a3:
        return 'A3 (متوسط)';
      case PosterSize.wallPoster:
        return 'ملصق حائط كبير (70×100 سم)';
    }
  }

  // Width/height in PDF points (72 pt = 1 inch)
  double get widthPt {
    switch (this) {
      case PosterSize.a4:
        return 595.3;
      case PosterSize.a3:
        return 841.9;
      case PosterSize.wallPoster:
        return 1984.3; // ~70cm
    }
  }

  double get heightPt {
    switch (this) {
      case PosterSize.a4:
        return 841.9;
      case PosterSize.a3:
        return 1190.6;
      case PosterSize.wallPoster:
        return 2834.6; // ~100cm
    }
  }
}

class PosterTemplate {
  final String id;
  final String title;
  final String category; // شهادة تقدير / بادج / ملصق حائط / بطاقة تهنئة
  final String description;
  final int colorIndex;
  final IconData icon;
  final bool isPremium;

  const PosterTemplate({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.colorIndex,
    required this.icon,
    this.isPremium = false,
  });
}
