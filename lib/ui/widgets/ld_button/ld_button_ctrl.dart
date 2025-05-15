// lib/ui/widgets/ld_button/ld_button_ctrl.dart
// Controlador per al widget LdButton
// Created: 2025/05/13 dl. GPT(JIQ)

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';

class LdButtonCtrl extends LdWidgetCtrlAbs<LdButton> {
  // CONSTRUCTOR ==========================================
  LdButtonCtrl(super.pWidget);

  // MÈTODE D'INICIALITZACIÓ ===============================
  @override
  void initialize() {
    Debug.info("$tag: Inicialització del controlador LdButton");
    if (model == null) {
      model = LdButtonModel.fromMap(widget.config);
    }
  }

  // CONSTRUCCIÓ DEL MODEL ================================
  // (eliminat: inicialització delegada a initialize())

  // GETTERS DE RENDERITZACIÓ =============================
  String get label => (model as LdButtonModel?)?.label ?? "";
  IconData? get icon => (model as LdButtonModel?)?.icon;
  ButtonStyle? get style => (model as LdButtonModel?)?.style;

  // CONSTRUCCIÓ DEL CONTINGUT ============================
  @override
  Widget buildContent(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? _handlePressed : null,
      style: style,
      child: Text((model as LdButtonModel).label.tx())
    );
  }

  // GESTIÓ DE L'ACCIÓ =====================================
  void _handlePressed() {
    Debug.info("$tag: Botó premut");
    final callback = cWidget.config[efOnPressed];
    if (callback is VoidCallback) {
      callback();
    }
  }

  void press() => _handlePressed();

  // MÈTODES REQUERITS ====================================
  @override
  void update() {}

  @override
  void onEvent(event) {}
}
