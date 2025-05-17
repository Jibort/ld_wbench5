// lib/ui/widgets/ld_theme_selector/ld_theme_selector_model.dart
// Model de dades per al selector de temes
// Created: 2025/05/09 dv. 

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_selector/ld_theme_selector.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Model de dades per al selector de temes
class LdThemeSelectorModel extends LdWidgetModelAbs<LdThemeSelector> {
  /// Mode de tema actual
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      notifyListeners(() {
        _themeMode = mode;
        Debug.info("$tag: Mode de tema canviat a ${mode.toString()}");
      });
    }
  }
  
  /// Tema actual
  String _themeName = themeSabina;
  String get themeName => _themeName;
  set themeName(String pName) {
    if (_themeName != pName) {
      notifyListeners(() {
        _themeName = pName;
        Debug.info("$tag: Tema canviat a $pName}");
      });
    }
  }
  
  /// Constructor
  LdThemeSelectorModel(
    super.pWidget, {
    required ThemeMode pInitialMode,
    required String pInitialTheme,
  }) {
    _themeMode = pInitialMode;
    _themeName = pInitialTheme;
    Debug.info("$tag: Model inicialitzat amb mode ${pInitialMode.toString()} i tema $pInitialTheme");
  }
  
  /// Retorna un mapa amb els membres del model
  @override
  MapDyns toMap() {
    MapDyns map = super.toMap();
    map.addAll({
      'themeMode': _themeMode.toString(),
      'themeName': _themeName.toString(),
    });
    return map;
  }
  
  /// Assigna els valors dels membres del model a partir d'un mapa
  @override
  void fromMap(LdMap pMap) {
    super.fromMap(pMap);
    
    // Convertir string a ThemeMode
    String? themeModeStr = pMap['themeMode'] as String?;
    if (themeModeStr != null) {
      if (themeModeStr == ThemeMode.dark.toString()) {
        _themeMode = ThemeMode.dark;
      } else if (themeModeStr == ThemeMode.light.toString()) {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.system;
      }
    }
    
    // Convertir string a String
    String? themeNameStr = pMap['themeName'] as String?;
    if (themeNameStr != null) {
      for (String name in lstThemes) {
        if (name.toString() == themeNameStr) {
          _themeName = name;
          break;
        }
      }
    }
  }
}