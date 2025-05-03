// lib/utils/color_extensions.dart
// Extensions per a facilitar el treball amb colors.
// Created: 2025/05/03 ds JIQ

import 'package:flutter/animation.dart';

extension ColorExtensions on Color {
  /// Aplica un nivell d'alpha dins el rang {0, .., 1}.
  Color setOpacity(double pPercent) {
    if (pPercent < 0.0) pPercent = 0.0;
    if (pPercent > 1.0) pPercent = 1.0;
    return withAlpha((pPercent * 255.0).round());
  }
}
