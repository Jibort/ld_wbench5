// lib/ui/widgets/ld_theme_viewer/ld_theme_viewer.dart
// Widget per visualitzar els colors disponibles en el tema actual
// Created: 2025/05/09 dv.
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_viewer/ld_theme_viewer_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_viewer/ld_theme_viewer_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'ld_theme_viewer_ctrl.dart';
export 'ld_theme_viewer_model.dart';

/// Widget per visualitzar els colors disponibles en el tema actual
class   LdThemeViewer 
extends LdWidgetAbs {
  /// Constructor
  LdThemeViewer({
    Key? key,
    super.pTag,
    bool showTextTheme = true,
    bool showColorScheme = true,
    bool compact = false,
  }) : super(pKey: key, pConfig: {
    // Configuració del controlador (cf)
    cfShowTextTheme: showTextTheme,
    cfShowColorScheme: showColorScheme,
    cfCompact: compact,
  }) {
    Debug.info("$tag: Visualitzador de temes creat");
  }

  @override
  LdThemeViewerCtrl createCtrl() => LdThemeViewerCtrl(this);

  // ACCESSORS PER A COMPATIBILITAT
  LdThemeViewerModel? get model {
    final ctrl = wCtrl;
    if (ctrl is LdThemeViewerCtrl) {
      return ctrl.model as LdThemeViewerModel?;
    }
    return null;
  }

  LdThemeViewerCtrl? get controller {
    final ctrl = wCtrl;
    if (ctrl is LdThemeViewerCtrl) {
      return ctrl;
    }
    return null;
  }

  // PROPIETATS DE CONFIGURACIÓ
  bool get showTextTheme => config[cfShowTextTheme] as bool? ?? true;
  bool get showColorScheme => config[cfShowColorScheme] as bool? ?? true;
  bool get compact => config[cfCompact] as bool? ?? false;
}