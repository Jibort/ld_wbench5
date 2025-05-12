// lib/ui/widgets/ld_button.dart
// Botó personalitzat de Sabina
// Created: 2025/04/29 DT. CLA[JIQ]

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button_model.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';

class   LdButton 
extends LdWidgetAbs {
  /// Constructor principal
  LdButton({
    String? pTag,
    String text = "",
    IconData? icon,
    VoidCallback? onPressed,
    ButtonStyle? style,
    bool isEnabled = true,
    bool isVisible = true,
  }) : super(pConfig: {
    // Propietats d'identificació
    cfTag: pTag ?? "LdButton_${DateTime.now().millisecondsSinceEpoch}",
    
    // Propietats del CONTROLADOR (cf) - configuració visual i comportament
    cfIsVisible: isVisible,
    cfIsEnabled: isEnabled,
    cfButtonText: text,
    cfIcon: icon,
    cfButtonStyle: style,
    
    // Propietats d'EVENTS (ef)
    efOnPressed: onPressed,
  }) {
    Debug.info("$tag: LdButton creat amb configuració");
  }

  /// Constructor alternatiu a partir d'un mapa
  LdButton.fromMap(LdMap<dynamic> configMap)
    : super(pConfig: configMap) {
    Debug.info("$tag: LdButton creat des d'un mapa");
  }

  @override
  LdWidgetCtrlAbs createCtrl() {
    return LdButtonCtrl(this);
  }

  // ACCESSORS PER A COMPATIBILITAT
  LdButtonModel? get model {
    final ctrl = wCtrl;
    if (ctrl is LdButtonCtrl) {
      return ctrl.model as LdButtonModel?;
    }
    return null;
  }

  LdButtonCtrl? get controller {
    final ctrl = wCtrl;
    if (ctrl is LdButtonCtrl) {
      return ctrl;
    }
    return null;
  }

  // PROPIETATS DE CONFIGURACIÓ
  String get text {
    return config[cfButtonText] as String? ?? "";
  }

  IconData? get icon {
    return config[cfIcon] as IconData?;
  }

  ButtonStyle? get style {
    return config[cfButtonStyle] as ButtonStyle?;
  }

  // MÈTODES DEL CONTROLADOR
  void press() {
    controller?.press();
  }
}