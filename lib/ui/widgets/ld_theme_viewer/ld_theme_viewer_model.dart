// lib/ui/widgets/ld_theme_viewer/ld_theme_viewer_model.dart
// Model de dades per al visualitzador de temes
// Created: 2025/05/09 dv.

import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_viewer/ld_theme_viewer.dart';

/// Model de dades per al visualitzador de temes
class   LdThemeViewerModel 
extends LdWidgetModelAbs<LdThemeViewer> {
  /// Constructor
  LdThemeViewerModel(super.pWidget);
  
  // Aquest model no té dades específiques a gestionar,
  // només usa les propietats del tema actual a través del context
}