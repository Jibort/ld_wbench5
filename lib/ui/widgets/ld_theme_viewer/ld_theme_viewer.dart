// lib/ui/widgets/ld_theme_viewer/ld_theme_viewer.dart
// Widget per visualitzar els colors disponibles en el tema actual
// Created: 2025/05/09 dv.

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
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
    super.key,
    super.pTag,
    bool showTextTheme = true,
    bool showColorScheme = true,
    bool compact = false,
  }) {
    Debug.info("$tag: Creant visualitzador de temes");
    
    // Inicialitzar el model buit (no necessitem guardar dades específiques)
    wModel = LdThemeViewerModel(this);
    
    // Inicialitzar el controlador amb les opcions de visualització
    wCtrl = LdThemeViewerCtrl(
      this,
      showTextTheme: showTextTheme,
      showColorScheme: showColorScheme,
      compact: compact,
    );
    
    Debug.info("$tag: Visualitzador de temes creat");
  }
}