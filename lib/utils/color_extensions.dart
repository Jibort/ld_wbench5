// lib/utils/color_extensions.dart
// Extensions per a facilitar el treball amb colors.
// Created: 2025/05/03 ds JIQ
// Updated: 2025/05/08 dj CLA - Eliminació de mètodes i propietats deprecades

import 'package:flutter/material.dart';

/// Extensions per a facilitar el treball amb colors
extension ColorExtensions on Color {
  /// Aplica un nivell d'alpha dins el rang {0, .., 1}.
  Color setOpacity(double pPercent) {
    pPercent = pPercent.clamp(0.0, 1.0);
    return Color.fromARGB(
      ((pPercent * 255.0).round()),
      (this >> 16) & 0xFF,
      (this >> 8) & 0xFF,
      this & 0xFF,
    );
  }
  
  /// Crea una còpia del color amb un nou valor alpha
  Color withAlphaValue(int alpha) {
    alpha = alpha.clamp(0, 255);
    return Color.fromARGB(
      alpha,
      (this >> 16) & 0xFF,
      (this >> 8) & 0xFF,
      this & 0xFF,
    );
  }
  
  /// Retorna una variant més clara del color
  Color lighter([double amount = 0.1]) {
    amount = amount.clamp(0.0, 1.0);
    final hsl = HSLColor.fromColor(this);
    final hslLighter = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLighter.toColor();
  }
  
  /// Retorna una variant més fosca del color
  Color darker([double amount = 0.1]) {
    amount = amount.clamp(0.0, 1.0);
    final hsl = HSLColor.fromColor(this);
    final hslDarker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDarker.toColor();
  }
  
  /// Retorna una variant amb més saturació del color
  Color moreVivid([double amount = 0.1]) {
    amount = amount.clamp(0.0, 1.0);
    final hsl = HSLColor.fromColor(this);
    final hslMoreVivid = hsl.withSaturation((hsl.saturation + amount).clamp(0.0, 1.0));
    return hslMoreVivid.toColor();
  }
  
  /// Retorna una variant amb menys saturació del color
  Color lessVivid([double amount = 0.1]) {
    amount = amount.clamp(0.0, 1.0);
    final hsl = HSLColor.fromColor(this);
    final hslLessVivid = hsl.withSaturation((hsl.saturation - amount).clamp(0.0, 1.0));
    return hslLessVivid.toColor();
  }
  
  /// Retorna una variant del color adaptada per contrast sobre fons clar/fosc
  Color adaptiveContrast(Brightness brightness) {
    return brightness == Brightness.dark ? lighter(0.2) : darker(0.2);
  }
  
  /// Converteix el color a una cadena de text hexadecimal
  String toHex({bool withPound = true, bool includeAlpha = false}) {
    final buffer = StringBuffer();
    if (withPound) buffer.write('#');
    
    if (includeAlpha) {
      final alphaValue = ((this >> 24) & 0xFF).toRadixString(16).padLeft(2, '0');
      buffer.write(alphaValue);
    }
    
    final redValue = ((this >> 16) & 0xFF).toRadixString(16).padLeft(2, '0');
    final greenValue = ((this >> 8) & 0xFF).toRadixString(16).padLeft(2, '0');
    final blueValue = (this & 0xFF).toRadixString(16).padLeft(2, '0');
    
    buffer.write(redValue);
    buffer.write(greenValue);
    buffer.write(blueValue);
    
    return buffer.toString().toUpperCase();
  }
}

/// Extensions per crear WidgetStateProperty per a colors
extension WidgetStateUtils on Color {
  /// Crea un WidgetStateProperty per a color de fons amb aquest color com a default
  WidgetStateProperty<Color> toBackgroundProperty({
    Color? hovered,
    Color? focused,
    Color? pressed,
    Color? disabled,
    Color? selected,
    Color? error, 
    Color? unselected,
  }) {
    return WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled) && disabled != null) {
        return disabled;
      }
      if (states.contains(WidgetState.error) && error != null) {
        return error;
      }
      if (states.contains(WidgetState.pressed) && pressed != null) {
        return pressed;
      }
      if (states.contains(WidgetState.selected) && selected != null) {
        return selected;
      }
      if (states.contains(WidgetState.focused) && focused != null) {
        return focused;
      }
      if (states.contains(WidgetState.hovered) && hovered != null) {
        return hovered;
      }
      return this;
    });
  }
  
  /// Crea un WidgetStateProperty per a color de text amb aquest color com a default
  WidgetStateProperty<Color> toForegroundProperty({
    Color? hovered,
    Color? focused,
    Color? pressed,
    Color? disabled,
    Color? selected,
    Color? error,
  }) {
    return WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled) && disabled != null) {
        return disabled;
      }
      if (states.contains(WidgetState.error) && error != null) {
        return error;
      }
      if (states.contains(WidgetState.pressed) && pressed != null) {
        return pressed;
      }
      if (states.contains(WidgetState.selected) && selected != null) {
        return selected;
      }
      if (states.contains(WidgetState.focused) && focused != null) {
        return focused;
      }
      if (states.contains(WidgetState.hovered) && hovered != null) {
        return hovered;
      }
      return this;
    });
  }
  
  /// Crea un WidgetStateProperty per a color de contorn amb aquest color com a default
  WidgetStateProperty<Color> toBorderProperty({
    Color? hovered,
    Color? focused,
    Color? pressed,
    Color? disabled,
    Color? selected,
    Color? error,
  }) {
    return WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled) && disabled != null) {
        return disabled;
      }
      if (states.contains(WidgetState.error) && error != null) {
        return error;
      }
      if (states.contains(WidgetState.pressed) && pressed != null) {
        return pressed;
      }
      if (states.contains(WidgetState.selected) && selected != null) {
        return selected;
      }
      if (states.contains(WidgetState.focused) && focused != null) {
        return focused;
      }
      if (states.contains(WidgetState.hovered) && hovered != null) {
        return hovered;
      }
      return this;
    });
  }
}