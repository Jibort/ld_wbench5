// lib/ui/widgets/ld_text/ld_text.dart
// Widget de text que suporta internacionalització automàtica
// Created: 2025/05/06 dt. CLA

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'ld_label_ctrl.dart';
export 'ld_label_model.dart';

/// Widget de text que suporta internacionalització automàtica
class      LdLabel 
extends    LdWidgetAbs
implements LdModelObserverIntf {
  /// Models externs dels quals aquest text és observador
  final Set<LdModelAbs> _externalModels = {};

  /// Registra aquest text com a observador d'un model extern
  void observeModel(LdModelAbs model) {
    _externalModels.add(model);
    model.attachObserver(this);
    Debug.info("$tag: Registrat com a observador d'un model extern");
  }

  /// Desregistra aquest text de tots els models externs
  void detachFromAllModels() {
    for (var model in _externalModels) {
      model.detachObserver(this);
    }
    _externalModels.clear();
    Debug.info("$tag: Desconnectat de tots els models externs");
  }

  /// Constructor
  LdLabel({
    super.key,
    super.pTag,
    required String text,
    List<dynamic>? args,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    Debug.info("$tag: Creant LdText amb text '$text'");
    
    // Crear primer el model amb el text i els arguments
    wModel = LdLabelModel(
      this,
      text: text, 
      args: args
    );
    
    // Després el controlador amb les propietats d'estil
    wCtrl = LdLabelCtrl(
      this,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow
    );
    
    Debug.info("$tag: LdText creat correctament");
  }

  /// Retorna els arguents per format actuals.
  List<dynamic>? get args => (wModel as LdLabelModel).args;

  /// Estableix els arguments per format
  set args(List<dynamic>? value) {
    (wModel as LdLabelModel).args = value;
  }

  bool needsUpdate(List<String> pList) => (args == pList);
  
}