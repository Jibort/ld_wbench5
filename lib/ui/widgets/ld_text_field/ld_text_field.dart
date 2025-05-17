// lib/ui/widgets/ld_text_field/ld_text_field.dart
// Widget per a l'edició de text amb suport per a internacionalització.
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/09 dv. CLA - distinció entre camps de models (mf), controladors (cf) i events (ef).
// Updated: 2025/05/10 ds. CLA - Adaptació completa a la nova arquitectura
// Updated: 2025/05/11 dg. CLA - Actualització de constants per diferenciar correctament mf/cf/ef
// Updated: 2025/05/12 dt. CLA - Afegit suport per al paràmetre key

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field_model.dart';

export 'ld_text_field_ctrl.dart';
export 'ld_text_field_model.dart';

/// Widget per a l'edició de text amb suport per a internacionalització
class   LdTextField 
extends LdWidgetAbs {
  /// Constructor principal
  LdTextField({
    Key? key,
    String? pTag,
    String initialText = "",
    String? label,
    String? helpText,
    String? errorMessage,
    bool hasError = false,
    bool allowNull = true,
    Function(String)? onTextChanged,
    bool canFocus = true,
    bool isEnabled = true,
    bool isVisible = true,
  }) : super(
    pKey: key,
    pTag: pTag ?? "LdTextField_${DateTime.now().millisecondsSinceEpoch}", 
    pConfig: {
    // Propietats d'identificació
    cfTag: pTag ?? "LdTextField_${DateTime.now().millisecondsSinceEpoch}",
    
    // Propietats del CONTROLADOR (cf) - configuració visual i comportament
    cfIsVisible: isVisible,
    cfCanFocus: canFocus,
    cfIsEnabled: isEnabled,
    cfLabel: label,
    cfHelpText: helpText,
    cfErrorMessage: errorMessage,
    cfHasError: hasError,
    cfAllowNull: allowNull,
    
    // Propietats del MODEL (mf) - dades reals
    mfInitialText: initialText,
    mfText: initialText,
    
    // Propietats d'EVENTS (ef)
    efOnTextChanged: onTextChanged,
  }) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: LdTextField creat amb configuració");
  }

  /// Constructor alternatiu a partir d'un mapa
  LdTextField.fromMap(MapDyns pConfig)
  : super(pConfig: pConfig) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: LdTextField creat des d'un mapa");
  }

  @override
  LdWidgetCtrlAbs createCtrl() => LdTextFieldCtrl(this);

  // PROPIETATS DEL MODEL
  String get text => (model as LdTextFieldModel?)?.text ?? "";
  set text(String value) {
    model?.updateField(mfText, value);
  }

  // PROPIETATS DE CONFIGURACIÓ
  String? get label {
    final config = super.config;
    return config[cfLabel] as String?;
  }

  String? get helpText {
    final config = super.config;
    return config[cfHelpText] as String?;
  }

  bool get hasError {
    final config = super.config;
    return config[cfHasError] as bool? ?? false;
  }

  String? get errorMessage {
    final config = super.config;
    return config[cfErrorMessage] as String?;
  }

  // MÈTODES DEL CONTROLADOR
  void appendText(String suffix) {
    (ctrl as LdTextFieldCtrl?)?.addText(suffix);
  }

  void prependText(String prefix) {
    (ctrl as LdTextFieldCtrl?)?.prependText(prefix);
  }

  void clearText() {
    (ctrl as LdTextFieldCtrl?)?.clearText();
  }

  void requestFocus() {
    (ctrl as LdTextFieldCtrl?)?.requestFocus();
  }

  void unfocus() {
    (ctrl as LdTextFieldCtrl?)?.focusNode.unfocus();
  }
}