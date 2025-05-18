// lib/ui/widgets/ld_check_box/ld_check_box.dart
// Widget de Checkbox personalitzat amb suport per a traducció, icones i indicador de focus.
// Created: 2025/05/17 ds. GPT(JIQ)
// Updated: 2025/05/18 ds. GEM - Implementació inicial del widget.
// Updated: 2025/05/19 dg. CLA - Correcció d'arquitectura, eliminació de dependència a TestPage2.

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_check_box/ld_check_box_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_check_box/ld_check_box_model.dart';

// Exportem els altres fitxers del widget perquè siguin accessibles des de fora del directori.
export 'ld_check_box_ctrl.dart';
export 'ld_check_box_model.dart';
export 'package:ld_wbench5/core/map_fields.dart'; // Exportar constants rellevants

/// Defineix la posició de l'indicador de selecció (el quadrat del checkbox).
enum CheckPosition { left, right }

/// Widget de Checkbox personalitzat segons l'arquitectura Sabina.
/// Proporciona opcions per a posició del check, icones i informació addicional.
class LdCheckBox extends LdWidgetAbs {

  // CONSTRUCTOR PRINCIPAL =================================
  /// Constructor.
  LdCheckBox({
    Key? key,
    super.pTag,
    bool initialChecked = false,
    required String labelText,
    List<String>? labelPosArgs,
    LdMap<String>? labelNamedArgs,
    IconData? leadingIcon,
    CheckPosition checkPosition = CheckPosition.left,
    String? infoTextKey,
    bool showInfoIcon = false,
    Function(bool)? onToggled,
    VoidCallback? onInfoTapped,
    bool isVisible = true,
    bool isEnabled = true,
    bool canFocus = true,
  }) : super(pKey: key, pConfig: {
          // Propietats base (cf*)
          cfTag: pTag, // Passar el tag a la configuració
          cfIsVisible: isVisible,
          cfIsEnabled: isEnabled, // Controla si el checkbox és interactiu
          cfCanFocus: canFocus, // Controla si el checkbox pot rebre focus

          // Propietats de Configuració (cf*)
          cfInitialChecked: initialChecked,
          cfLabel: labelText, // Utilitzem cfLabel per al text del label
          cfLabelPosArgs: labelPosArgs,
          cfLabelNamedArgs: labelNamedArgs,
          cfLeadingIcon: leadingIcon,
          cfCheckPosition: checkPosition.toString().split('.').last,
          cfInfoTextKey: infoTextKey,
          cfShowInfoIcon: showInfoIcon,

          // Propietats d'Events (ef*)
          efOnToggled: onToggled,
          efOnInfoTapped: onInfoTapped,

          // El model tindrà una propietat mfIsChecked que carregarà el seu estat inicial
          // des de cfInitialChecked al mètode fromMap del model, i després gestionarà els canvis.
          mfIsChecked: initialChecked, // Estat inicial
        }) {
    // logs inicials si calgués
    // Debug.info("$tag: Widget LdCheckBox creat amb label: '$labelText', initialChecked: $initialChecked");
  }

  // CONSTRUCTOR FROM MAP (Opcional) =======================
  LdCheckBox.fromMap(MapDyns configMap) : super(pConfig: configMap) {
    // El constructor base ja s'encarrega de processar el mapa.
    // Debug.info("$tag: Widget LdCheckBox creat des d'un mapa.");
  }

  // CONTROLADOR ASSOCIAT ==================================
  @override
  LdWidgetCtrlAbs createCtrl() {
    return LdCheckBoxCtrl(this);
  }

  // ACCÉS AL CONTROLADOR I MODEL AMB TIPUS SEGUR ===========
  /// Accés ràpid al controlador amb tipus segur.
  LdCheckBoxCtrl? get checkboxCtrl => ctrl as LdCheckBoxCtrl?;
  /// Accés ràpid al model amb tipus segur.
  LdCheckBoxModel? get checkboxModel => model as LdCheckBoxModel?;

  // MÈTODES D'ACTUALITZACIÓ (per control programàtic des de fora) =
  /// Estableix programàticament l'estat de selecció del checkbox.
  /// Aquesta acció notificarà al model i als seus observadors (inclòs el controlador).
  void setChecked(bool value) => checkboxModel?.setChecked(value);

  /// Obté l'estat de selecció actual des del model.
  bool get isChecked => checkboxModel?.isChecked ?? false;

  /// Alterna programàticament l'estat de selecció.
  /// Aquesta acció notificarà al model i als seus observadors (inclòs el controlador).
  void toggle() => checkboxModel?.toggle();

  /// Actualitza els arguments de traducció del label.
  /// Aquesta acció notificarà al model i als seus observadors.
  void updateLabelArgs({
    List<String>? positionalArgs,
    LdMap<String>? namedArgs,
  }) => checkboxModel?.updateLabelArgs(positionalArgs: positionalArgs, namedArgs: namedArgs);
}