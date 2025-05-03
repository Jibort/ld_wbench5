// ld_widget_abs.dart
// Widget base simplificat per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/03 ds. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/utils/once_set.dart';

export 'ld_widget_ctrl_abs.dart';
export 'ld_widget_model_abs.dart';

/// Widget base que proporciona funcionalitats comunes
abstract class LdWidgetAbs
extends  StatefulWidget 
with     LdTaggableMixin {
  // CONTROLADOR ==============================================================
  /// Controlador del widget
  final OnceSet<LdWidgetCtrlAbs<LdWidgetAbs>> _ctrl = OnceSet<LdWidgetCtrlAbs<LdWidgetAbs>>();
  /// Retorna el controlador del widget
  LdWidgetCtrlAbs<LdWidgetAbs> get wCtrl => _ctrl.get(pCouldBeNull: false)!;
  /// Estableix el controlador del widget
  set wCtrl(LdWidgetCtrlAbs<LdWidgetAbs> pCtrl) => _ctrl.set(pCtrl);

  // MODEL ====================================================================
  /// Model del widget
  final OnceSet<LdWidgetModelAbs<LdWidgetAbs>> _model = OnceSet<LdWidgetModelAbs<LdWidgetAbs>>();
  /// Retorna el model del widget.
  LdWidgetModelAbs<LdWidgetAbs> get wModel => _model.get(pCouldBeNull: false)!;
  /// Estableix el model del widget.
  set wModel(LdWidgetModelAbs pModel) => _model.set(pModel);
  /// Indica si el widget té un model assignat
  bool get hasModel => _model.isSet;

  /// Crea un nou widget base
  LdWidgetAbs({
    super.key, 
    String? pTag,
    bool isVisible = true,
    bool canFocus = true,
    bool isEnabled = true }) 
  { tag = (pTag != null) 
      ? pTag
      : className;
  }

  // 'StatefulWidget': Retorna el controlador de l'aplicació.
  @override
  State<LdWidgetAbs> createState() => wCtrl;
}