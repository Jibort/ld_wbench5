// lib/utils/theme_utils.dart
// Utilitats per a treballar amb temes de manera més senzilla.
// Created: 2025/05/08 dj. CLA

import 'package:flutter/material.dart';

/// Classe d'utilitats per a temes
class ThemeUtils {
  /// Desactiva la creació d'instàncies
  ThemeUtils._();
  
  /// Crea un `EdgeInsetsGeometry` per a usar amb `WidgetStateProperty`
  static WidgetStateProperty<EdgeInsetsGeometry> padding(EdgeInsetsGeometry value) => 
      WidgetStateProperty.all<EdgeInsetsGeometry>(value);
  
  /// Crea un `double` per a usar amb `WidgetStateProperty`
  static WidgetStateProperty<double> elevation(double value) => 
      WidgetStateProperty.all<double>(value);
  
  /// Crea un `OutlinedBorder` per a usar amb `WidgetStateProperty`
  static WidgetStateProperty<OutlinedBorder> shape(OutlinedBorder value) => 
      WidgetStateProperty.all<OutlinedBorder>(value);
  
  /// Crea un `BorderSide` per a usar amb `WidgetStateProperty`
  static WidgetStateProperty<BorderSide> border(BorderSide value) => 
      WidgetStateProperty.all<BorderSide>(value);
      
  /// Crea un `TextStyle` per a usar amb `WidgetStateProperty`
  static WidgetStateProperty<TextStyle> textStyle(TextStyle value) => 
      WidgetStateProperty.all<TextStyle>(value);
      
  /// Crea un `MouseCursor` per a usar amb `WidgetStateProperty`
  static WidgetStateProperty<MouseCursor> cursor(MouseCursor value) => 
      WidgetStateProperty.all<MouseCursor>(value);
  
  /// Crea una propietat de WidgetState per a un color de fons
  static WidgetStateProperty<Color> backgroundColor(
    Color defaultColor, {
    Color? hovered,
    Color? focused,
    Color? pressed,
    Color? disabled,
    Color? selected,
    Color? error,
  }) => WidgetStateProperty.resolveWith<Color>((states) {
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
      return defaultColor;
    });
  
  /// Crea una propietat de WidgetState per a un color de text
  static WidgetStateProperty<Color> foregroundColor(
    Color defaultColor, {
    Color? hovered,
    Color? focused,
    Color? pressed,
    Color? disabled,
    Color? selected,
    Color? error,
  }) => WidgetStateProperty.resolveWith<Color>((states) {
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
      return defaultColor;
    });
    
  /// Crea una propietat de WidgetState per a un color de vora
  static WidgetStateProperty<Color> borderColor(
    Color defaultColor, {
    Color? hovered,
    Color? focused,
    Color? pressed,
    Color? disabled,
    Color? selected,
    Color? error,
  }) => WidgetStateProperty.resolveWith<Color>((states) {
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
      return defaultColor;
    });
  
  /// Crea una propietat de WidgetState per a un vora en funció de l'estat
  static WidgetStateProperty<BorderSide?> statefulBorder({
    BorderSide? defaultBorder,
    BorderSide? hovered,
    BorderSide? focused,
    BorderSide? pressed,
    BorderSide? disabled,
    BorderSide? selected,
    BorderSide? error,
  }) => WidgetStateProperty.resolveWith<BorderSide?>((states) {
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
      return defaultBorder;
    });
  
  /// Crea una propietat de WidgetState per a una ombra en funció de l'estat
  static WidgetStateProperty<double> statefulElevation({
    double defaultElevation = 0.0,
    double? hovered,
    double? focused,
    double? pressed,
    double? disabled,
    double? dragged,
  }) => WidgetStateProperty.resolveWith<double>((states) {
      if (states.contains(WidgetState.disabled) && disabled != null) {
        return disabled;
      }
      if (states.contains(WidgetState.dragged) && dragged != null) {
        return dragged;
      }
      if (states.contains(WidgetState.pressed) && pressed != null) {
        return pressed;
      }
      if (states.contains(WidgetState.focused) && focused != null) {
        return focused;
      }
      if (states.contains(WidgetState.hovered) && hovered != null) {
        return hovered;
      }
      return defaultElevation;
    });
  
  /// Obté una petita pre-visualització d'un color
  static Widget colorPreview(Color color, {double size = 24}) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey.shade300, width: 1),
    ),
  );
  
  /// Obté un giny per seleccionar el mode de tema
  static Widget buildThemeModeSelector(
    ThemeMode currentMode, 
    Function(ThemeMode) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.brightness_auto),
          onPressed: () => onChanged(ThemeMode.system),
          style: IconButton.styleFrom(
            foregroundColor: currentMode == ThemeMode.system ? Colors.blue : null,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.brightness_high),
          onPressed: () => onChanged(ThemeMode.light),
          style: IconButton.styleFrom(
            foregroundColor: currentMode == ThemeMode.light ? Colors.amber : null,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.brightness_4),
          onPressed: () => onChanged(ThemeMode.dark),
          style: IconButton.styleFrom(
            foregroundColor: currentMode == ThemeMode.dark ? Colors.indigo : null,
          ),
        ),
      ],
    );
  }
  
  /// Crea els estils del tema per a checkboxes
  static CheckboxThemeData createCheckboxTheme(Color primaryColor) {
    return CheckboxThemeData(
      // Utilitzem WidgetStateProperty.resolveWith en lloc de toBackgroundProperty
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.grey[400]!;
      }),
      checkColor: WidgetStateProperty.all<Color>(Colors.white),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      side: BorderSide(color: Colors.grey[400]!, width: 1.5),
    );
  }
  
  /// Crea un ColorScheme clar
  static ColorScheme createLightColorScheme({
    required Color primary,
    required Color onPrimary,
    required Color secondary,
    required Color onSecondary,
    required Color surface,
    required Color onSurface,
    required Color error,
    required Color onError,
    required Color background,
  }) {
    return ColorScheme.light(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      surface: surface,
      onSurface: onSurface,
      error: error,
      onError: onError,
      // Nota: onBackground s'ha eliminat perquè està deprecat
      // S'ha d'utilitzar onSurface en el seu lloc
    );
  }

  /// Crea un ColorScheme fosc
  static ColorScheme createDarkColorScheme({
    required Color primary,
    required Color onPrimary,
    required Color secondary,
    required Color onSecondary,
    required Color surface,
    required Color onSurface,
    required Color error,
    required Color onError,
    required Color background,
  }) {
    return ColorScheme.dark(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      surface: surface,
      onSurface: onSurface,
      error: error,
      onError: onError,
      // Nota: onBackground s'ha eliminat perquè està deprecat
      // S'ha d'utilitzar onSurface en el seu lloc
    );
  }
}