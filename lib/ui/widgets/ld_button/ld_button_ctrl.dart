// lib/ui/widgets/ld_button/ld_button_ctrl.dart
// Controlador per al widget LdButton
// Created: 2025/05/13 dl. GPT(JIQ)

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';

import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/utils/debug.dart';

class LdButtonCtrl extends LdWidgetCtrlAbs<LdButton> with AutomaticKeepAliveClientMixin {
  // CONSTRUCTOR ==========================================
  LdButtonCtrl(super.pWidget);

  // MEMBRES ==============================================
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: Cridar al super.build per preservar l'AutomaticKeepAliveClientMixin
    super.build(context);
    
    // Retornar el contingut
    return buildContent(context);
  }

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

  // GETTERS DE RENDERITZACIÓ =============================
  String get label => (model as LdButtonModel?)?.label ?? "";
  IconData? get icon => (model as LdButtonModel?)?.icon;
  ButtonStyle? get style => (model as LdButtonModel?)?.style;

  // CONSTRUCCIÓ DEL CONTINGUT ============================
  @override
  Widget buildContent(BuildContext context) {
    final buttonModel = model as LdButtonModel?;
    if (buttonModel == null) {
      Debug.warn("$tag: Model no disponible, mostrant SizedBox buit");
      return const SizedBox.shrink();
    }

    // Obtenir tots els paràmetres del model
    final label = buttonModel.translatedLabel;

    return ElevatedButton(
      onPressed: isEnabled ? _handlePressed : null,
      style: buttonModel.style,
      child: Text(label)
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

  // MÈTODES D'ACTUALITZACIÓ ===============================
  /// Mètode per actualitzar el label
  void updateLabel(String pNewLabel) {
    final buttonModel = model as LdButtonModel?;
    if (buttonModel != null) {
      buttonModel.label = pNewLabel;
      
      // Forçar actualització si està muntat
      if (mounted) {
        setState(() {
          Debug.info("$tag: Label actualitzat a '$pNewLabel'");
        });
      }
    }
  }

  /// Actualitza els paràmetres de traducció
  void updateTranslationParams({
    List<String>? positionalArgs,
    LdMap<String>? namedArgs,
  }) {
    final buttonModel = model as LdButtonModel?;
    if (buttonModel != null) {
      // Actualitzar arguments
      if (positionalArgs != null) {
        buttonModel.positionalArgs = positionalArgs;
      }
      if (namedArgs != null) {
        buttonModel.namedArgs = namedArgs;
      }
      
      // Forçar actualització si està muntat
      if (mounted) {
        setState(() {
          Debug.info("$tag: Arguments de traducció actualitzats");
        });
      }
    }
  }

  // MÈTODES REQUERITS ====================================
  @override
  void update() {}

  @override
  void onEvent(event) {}
}