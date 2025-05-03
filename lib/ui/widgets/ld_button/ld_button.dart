// lib/ui/widgets/ld_button.dart
// Botó personalitzat de Sabina
// Created: 2025/04/29 DT. CLA[JIQ]

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button_model.dart';

export 'ld_button_ctrl.dart';
export 'ld_button_model.dart';

/// Botó personalitzat de Sabina
class LdButton extends LdWidgetAbs {
  /// Constructor
  LdButton({
    super.key,
    super.pTag,
    String? text,
    IconData? pIcon,
    VoidCallback? onPressed,
    Color? backgroundColor,
  }) { 
    wModel = LdButtonModel(this,
      pText: text,
      pIcon: pIcon,
    );
    wCtrl = LdButtonCtrl(this,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
    );
  }
}