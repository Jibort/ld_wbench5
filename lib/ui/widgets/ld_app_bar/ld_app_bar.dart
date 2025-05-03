// lib/ui/widgets/ld_app_bar.dart
// Widget de la barra d'aplicació personalitzada
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar_model.dart';

export 'ld_app_bar_ctrl.dart';
export 'ld_app_bar_model.dart';

/// Widget de la barra d'aplicació personalitzada
class   LdAppBar
extends LdWidgetAbs {
  /// Constructor
  LdAppBar({
    super.key,
    super.pTag, 
    required String pTitle,
    String? pSubTitle,
    List<Widget>? actions })
  { wModel = LdAppBarModel(this,
      pTitle:    pTitle, 
      pSubTitle: pSubTitle);
    wCtrl = LdAppBarCtrl(this,
      actions: actions);
  }
}
