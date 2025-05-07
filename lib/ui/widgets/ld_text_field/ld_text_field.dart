// lib/ui/widgets/ld_text_field/ld_text_field.dart
// Widget per a l'edició de text amb suport per a internacionalització.
// Created: 2025/05/06 dt. CLA

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'ld_text_field_ctrl.dart';
export 'ld_text_field_model.dart';

/// Widget per a l'edició de text amb suport per a internacionalització
class LdTextField extends LdWidgetAbs {
  /// Constructor
  LdTextField({
    super.key,
    super.pTag,
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
  }) {
    Debug.info("$tag: Creant LdTextField");
    
    // Inicialitzar el model i el controlador
    wModel = LdTextFieldModel(
      this,
      initialText: initialText,
      label: label,
      helpText: helpText,
      errorMessage: errorMessage,
      hasError: hasError,
      allowNull: allowNull,
      onTextChanged: onTextChanged,
    );
    
    wCtrl = LdTextFieldCtrl(
      this,
      initialText: initialText,
      canFocus: canFocus,
      isEnabled: isEnabled,
      isVisible: isVisible,
    );
    
    Debug.info("$tag: LdTextField creat correctament");
  }
  
  /// Accelerador d'accés al model
  LdTextFieldModel get model => wModel as LdTextFieldModel;
  
  /// Accelerador d'accés al controlador
  LdTextFieldCtrl get controller => wCtrl as LdTextFieldCtrl;
  
  /// Retorna el text actual
  String get text => model.text;
  
  /// Estableix el text
  set text(String value) => model.text = value;
  
  /// Afegeix text al final - ara delegada al controlador
  void appendText(String suffix) => controller.addText(suffix);
  
  /// Afegeix text al principi - ara delegada al controlador
  void prependText(String prefix) => controller.prependText(prefix);
  
  /// Neteja el text - ara delegada al controlador
  void clearText() => controller.clearText();
  
  /// Estableix l'etiqueta
  set label(String value) => model.label = value;
  
  /// Estableix el text d'ajuda
  set helpText(String? value) => model.helpText = value;
  
  /// Estableix l'estat d'error
  set hasError(bool value) => model.hasError = value;
  
  /// Estableix el missatge d'error
  set errorMessage(String? value) => model.errorMessage = value;
}