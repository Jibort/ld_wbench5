// lib/ui/widgets/ld_button/ld_button_ctrl.dart
// Controlador per al widget LdButton
// Created: 2025/05/13 dl. GPT(JIQ)

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';

class LdButtonCtrl extends LdWidgetCtrlAbs<LdButton> {
  // CONSTRUCTOR ==========================================
  LdButtonCtrl(super.pWidget);

  // MÈTODE D'INICIALITZACIÓ ===============================
  @override
  void initialize() {
    // Crear el model amb la configuració del widget
    if (model == null) {
      // Assegurar-nos que el mapa de configuració té les propietats mínimes
      final modelConfig = {
        cfTag: tag, // Sempre utilitzar tag del controlador
        cfLabel: widget.config[cfLabel] as String? ?? '',
        cfIsEnabled: widget.config[cfIsEnabled] as bool? ?? true,
        cfButtonType: 'elevated', // Valor per defecte
      };
      
      // Afegir altres propietats opcionals només si no són nul·les
      final positionalArgs = widget.config[cfPositionalArgs];
      if (positionalArgs != null) {
        modelConfig[cfPositionalArgs] = positionalArgs;
      }
      
      final namedArgs = widget.config[cfNamedArgs];
      if (namedArgs != null) {
        modelConfig[cfNamedArgs] = namedArgs;
      }
      
      final buttonType = widget.config[cfButtonType];
      if (buttonType != null) {
        modelConfig[cfButtonType] = buttonType;
      }
      
      model = LdButtonModel.fromMap(modelConfig);
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
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Botó premut");
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
