// lib/ui/widgets/ld_text_field/ld_text_field.dart
// Widget per a l'edició de text amb suport per a internacionalització.
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/09 dv. CLA - distinció entre camps de models (mf), controladors (cf) i events (ef).
// Updated: 2025/05/11 ds. CLA - Adaptació completa a la nova arquitectura

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field_model.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';

export 'ld_text_field_ctrl.dart';
export 'ld_text_field_model.dart';

/// Widget per a l'edició de text amb suport per a internacionalització
class   LdTextField 
extends LdWidgetAbs {
  /// Constructor principal
  LdTextField({
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
  }) : super(config: {
    // Identificació
    cfTag: pTag ?? "LdTextField_${DateTime.now().millisecondsSinceEpoch}",
    
    // Propietats del MODEL (mf) - dades reals
    mfInitialText: initialText,
    mfLabel: label,
    mfHelpText: helpText,
    mfErrorMessage: errorMessage,
    mfHasError: hasError,
    mfAllowNull: allowNull,
    
    // Propietats del CONTROLADOR (cf) - comportament
    cfOnTextChanged: onTextChanged,
    cfCanFocus: canFocus,
    cfIsEnabled: isEnabled,
    cfIsVisible: isVisible,
  }) {
    Debug.info("$tag: LdTextField creat amb configuració");
  }

  /// Constructor alternatiu a partir d'un mapa
  LdTextField.fromMap(LdMap<dynamic> configMap) 
      : super(config: configMap) {
    Debug.info("$tag: LdTextField creat des d'un mapa");
  }

  @override
  LdWidgetCtrlAbs createController() {
    return LdTextFieldCtrl(this);
  }
  
  // ACCESSORS PER A COMPATIBILITAT =========================================
  /// Retorna el model tipat
  LdTextFieldModel? get model {
    final ctrl = wCtrl;
    if (ctrl is LdTextFieldCtrl) {
      return ctrl.model as LdTextFieldModel?;
    }
    return null;
  }
  
  /// Retorna el controlador tipat
  LdTextFieldCtrl? get controller {
    final ctrl = wCtrl;
    if (ctrl is LdTextFieldCtrl) {
      return ctrl;
    }
    return null;
  }
  
  // PROPIETATS DEL MODEL ===================================================
  /// Retorna el text actual
  String get text => model?.text ?? "";
  
  /// Estableix el text
  set text(String value) {
    model?.updateField(mfText, value);
  }
  
  /// Retorna l'etiqueta
  String? get label => model?.label;
  
  /// Estableix l'etiqueta
  set label(String? value) {
    model?.updateField(mfLabel, value);
  }
  
  /// Retorna el text d'ajuda
  String? get helpText => model?.helpText;
  
  /// Estableix el text d'ajuda
  set helpText(String? value) {
    model?.updateField(mfHelpText, value);
  }
  
  /// Retorna si té error
  bool get hasError => model?.hasError ?? false;
  
  /// Estableix l'estat d'error
  set hasError(bool value) {
    model?.updateField(mfHasError, value);
  }
  
  /// Retorna el missatge d'error
  String? get errorMessage => model?.errorMessage;
  
  /// Estableix el missatge d'error
  set errorMessage(String? value) {
    model?.updateField(mfErrorMessage, value);
  }
  
  // MÈTODES DEL CONTROLADOR ================================================
  /// Afegeix text al final
  void appendText(String suffix) {
    controller?.addText(suffix);
  }
  
  /// Afegeix text al principi
  void prependText(String prefix) {
    controller?.prependText(prefix);
  }
  
  /// Neteja el text
  void clearText() {
    controller?.clearText();
  }
  
  /// Demana el focus
  void requestFocus() {
    controller?.requestFocus();
  }
  
  /// Allibera el focus
  void unfocus() {
    controller?.focusNode.unfocus();
  }
}