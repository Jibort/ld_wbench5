// lib/ui/widgets/ld_text_field/ld_text_field.dart
// Widget per a l'edició de text amb suport per a internacionalització.
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/09 dv. CLA - distinció entre camps de models (mf), controladors (cf) i events (ef).

import 'package:flutter/cupertino.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field_model.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';

export 'ld_text_field_ctrl.dart';
export 'ld_text_field_model.dart';

/// Widget per a l'edició de text amb suport per a internacionalització
class   LdTextField 
extends LdWidgetAbs {
  /// CONSTRUCTORS ====================
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
    Debug.info("$tag: Creant $className");

    // Inicialitzar el mapa de configuració del widget.
    config.addAll({
        // Camps del MODEL (mf) - dades reals
      mfInitialText: initialText,
      mfLabel: label,
      mfHelpText: helpText,
      mfErrorMessage: errorMessage,
      mfHasError: hasError,
      mfAllowNull: allowNull,
      
      // Camps del CONTROLADOR (cf) - comportament
      cfOnTextChanged: onTextChanged,
      cfCanFocus: canFocus,
      cfIsEnabled: isEnabled,
      cfIsVisible: isVisible,
    });

    // CLA_4: JA NO INICIALITZEM AQUESTES INSTÀNCIES EN EL CONSTRUCTOR.
    // CLA_4: // Inicialitzar el model i el controlador
    // CLA_4: wModel = LdTextFieldModel(
    // CLA_4:   this,
    // CLA_4:   initialText: initialText,
    // CLA_4:   label: label,
    // CLA_4:   helpText: helpText,
    // CLA_4:   errorMessage: errorMessage,
    // CLA_4:   hasError: hasError,
    // CLA_4:   allowNull: allowNull,
    // CLA_4:   onTextChanged: onTextChanged,
    // CLA_4: );
    // CLA_4: 
    // CLA_4: wCtrl = LdTextFieldCtrl(
    // CLA_4:   this,
    // CLA_4:   initialText: initialText,
    // CLA_4:   canFocus: canFocus,
    // CLA_4:   isEnabled: isEnabled,
    // CLA_4:   isVisible: isVisible,
    // CLA_4: );
    
    Debug.info("$tag: $className creat correctament");
  }

  LdTextField.fromMap(LdMap<dynamic> configMap, { super.key }) {
    Debug.info("$tag: Creant $className des d'un mapa");
    // Inicialitzar el mapa de configuració del widget.
    config.addAll({
        // Camps del MODEL (mf) - dades reals
      mfInitialText: initialText,
      mfLabel: label,
      mfHelpText: helpText,
      mfErrorMessage: errorMessage,
      mfHasError: hasError,
      mfAllowNull: allowNull,
      
      // Camps del CONTROLADOR (cf) - comportament
      cfOnTextChanged: onTextChanged,
      cfCanFocus: canFocus,
      cfIsEnabled: isEnabled,
      cfIsVisible: isVisible,
    });
    Debug.info("$tag: $className creat correctament des d'un mapa");
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