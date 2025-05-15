// lib/ui/widgets/ld_theme_selector/ld_theme_selector.dart
// Widget per seleccionar entre els diferents temes disponibles
// Created: 2025/05/09 dv. 
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/ld_theme.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_selector/ld_theme_selector_ctrl.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'ld_theme_selector_ctrl.dart';
export 'ld_theme_selector_model.dart';

/// Widget per seleccionar entre els diferents temes disponibles
class LdThemeSelector extends LdWidgetAbs {
  /// Constructor
  LdThemeSelector({
    Key? key,
    super.pTag,
    bool displayMode = true,
    bool displayThemes = true,
    ThemeMode? initialMode,
    ThemeName? initialTheme,
    Function(ThemeMode)? onModeChanged,
    Function(ThemeName)? onThemeChanged,
  }) : super(pKey: key, pConfig: {
    // Configuració del controlador (cf)
    cfDisplayMode: displayMode,
    cfDisplayThemes: displayThemes,
    
    // Dades inicials del model (mf)
    'mfInitialMode': initialMode ?? LdTheme.s.themeMode,
    'mfInitialTheme': initialTheme ?? LdTheme.s.currentThemeName,
    
    // Callbacks (ef)
    'efOnModeChanged': onModeChanged,
    'efOnThemeChanged': onThemeChanged,
  }) {
    Debug.info("$tag: Selector de temes creat");
  }

  @override
  LdThemeSelectorCtrl createCtrl() => LdThemeSelectorCtrl(this);

  // PROPIETATS DE CONFIGURACIÓ
  bool get displayMode => config[cfDisplayMode] as bool? ?? true;
  bool get displayThemes => config[cfDisplayThemes] as bool? ?? true;
  Function(ThemeMode)? get onModeChanged => config['efOnModeChanged'] as Function(ThemeMode)?;
  Function(ThemeName)? get onThemeChanged => config['efOnThemeChanged'] as Function(ThemeName)?;
}