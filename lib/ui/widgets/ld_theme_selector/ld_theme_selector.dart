// lib/ui/widgets/ld_theme_selector/ld_theme_selector.dart
// Widget per seleccionar entre els diferents temes disponibles
// Created: 2025/05/09 dv. 

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/services/ld_theme.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_selector/ld_theme_selector_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_selector/ld_theme_selector_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'ld_theme_selector_ctrl.dart';
export 'ld_theme_selector_model.dart';

/// Widget per seleccionar entre els diferents temes disponibles
class LdThemeSelector extends LdWidgetAbs {
  /// Constructor
  LdThemeSelector({
    super.key,
    super.pTag,
    bool displayMode = true,
    bool displayThemes = true,
    ThemeMode? initialMode,
    ThemeName? initialTheme,
    Function(ThemeMode)? onModeChanged,
    Function(ThemeName)? onThemeChanged,
  }) {
    Debug.info("$tag: Creant selector de temes");
    
    // Inicialitzar el model amb els valors inicials
    wModel = LdThemeSelectorModel(
      this,
      initialMode: initialMode ?? LdTheme.s.themeMode,
      initialTheme: initialTheme ?? LdTheme.s.currentThemeName,
    );
    
    // Inicialitzar el controlador amb els callbacks i opcions de visualització
    wCtrl = LdThemeSelectorCtrl(
      this,
      displayMode: displayMode,
      displayThemes: displayThemes,
      onModeChanged: onModeChanged,
      onThemeChanged: onThemeChanged,
    );
    
    Debug.info("$tag: Selector de temes creat");
  }
}