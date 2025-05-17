// lib/ui/widgets/ld_theme_selector/ld_theme_selector.dart
// Widget per seleccionar entre els diferents temes disponibles
// Created: 2025/05/09 dv. 
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_selector/ld_theme_selector_ctrl.dart';

export 'ld_theme_selector_ctrl.dart';
export 'ld_theme_selector_model.dart';

/// Widget per seleccionar entre els diferents temes disponibles
class LdThemeSelector extends LdWidgetAbs {
  /// Constructor
  LdThemeSelector({
    Key? key,
    super.pTag,
    bool pDisplayMode = true,
    bool pDisplayThemes = true,
    ThemeMode? pInitialMode,
    String? pInitialTheme,
    Function(ThemeMode)? pfnOnModeChanged,
    Function(String)? pfnOnThemeChanged,
  }) : super(pKey: key, pConfig: {
    // Configuració del controlador (cf)
    cfDisplayMode: pDisplayMode,
    cfDisplayThemes: pDisplayThemes,
    
    // Dades inicials del model (mf)
    'mfInitialMode': pInitialMode ?? ThemeService.s.themeMode,
    'mfInitialTheme': pInitialTheme ?? ThemeService.s.currentThemeName,
    
    // Callbacks (ef)
    'efOnModeChanged': pfnOnModeChanged,
    'efOnThemeChanged': pfnOnThemeChanged,
  }) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Selector de temes creat");
  }

  @override
  LdThemeSelectorCtrl createCtrl() => LdThemeSelectorCtrl(this);

  // PROPIETATS DE CONFIGURACIÓ
  bool get displayMode => config[cfDisplayMode] as bool? ?? true;
  bool get displayThemes => config[cfDisplayThemes] as bool? ?? true;
  Function(String)? get onModeChanged => config[efOnModeChanged] as Function(String)?;
  Function(String)? get onThemeChanged => config['efOnThemeChanged'] as Function(String)?;
}