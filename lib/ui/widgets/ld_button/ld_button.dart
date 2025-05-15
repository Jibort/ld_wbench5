// lib/ui/widgets/ld_button/ld_button.dart
// Botó personalitzat de Sabina
// Created: 2025/04/29 DT. CLA[JIQ]
// Updated: 2025/05/13 dl. GPT(JIQ) - Imports i estil actualitzats

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button_ctrl.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'package:ld_wbench5/ui/widgets/ld_button/ld_button_ctrl.dart';
export 'package:ld_wbench5/ui/widgets/ld_button/ld_button_model.dart';

class LdButton extends LdWidgetAbs {
  // CONSTRUCTOR PRINCIPAL =================================
  LdButton({
    Key? key,
    super.pTag,
    String? text = "",
    IconData? icon,
    VoidCallback? onPressed,
    ButtonStyle? style,
    bool isEnabled = true,
    bool isVisible = true,
  }) : super(pKey: key, pConfig: {
          cfTag: pTag ?? "LdButton_${DateTime.now().millisecondsSinceEpoch}",
          cfIsVisible: isVisible,
          cfIsEnabled: isEnabled,
          cfLabel: text,
          cfIcon: icon,
          cfButtonStyle: style,
          efOnPressed: onPressed,
        }) {
    Debug.info("$tag: text pla: '$text', text traduït: '${(text??errInText).tx}'");
    Debug.info("$tag: LdButton creat amb configuració");
  }

  // CONSTRUCTOR FROM MAP ==================================
  LdButton.fromMap(MapDyns configMap)
      : super(pConfig: configMap) {
    Debug.info("$tag: LdButton creat des d'un mapa");
  }

  // CONTROLADOR ASSOCIAT ==================================
  @override
  LdWidgetCtrlAbs createCtrl() {
    return LdButtonCtrl(this);
  }

  // GETTERS DE CONFIGURACIÓ ===============================
  String get text => config[cfLabel] as String? ?? "";

  IconData? get icon => config[cfIcon] as IconData?;

  ButtonStyle? get style => config[cfButtonStyle] as ButtonStyle?;

  // ACCIÓ PROGRAMÀTICA =====================================
  void press() => (ctrl as LdButtonCtrl?)?.press();
}
