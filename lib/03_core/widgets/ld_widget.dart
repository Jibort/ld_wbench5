// ld_widget.dart
// Abstracció de tots els widgets fets servir per l'aplicació.
// CreatedAt 2025/04/13 dl. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/ld_bindings.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget_ctrl.dart';
import 'package:ld_wbench5/10_tools/only_once.dart';

export 'package:ld_wbench5/03_core/widgets/ld_widget_ctrl.dart';

/// Abstracció de tots els widgets fets servir per l'aplicació.
abstract class LdWidget<C extends LdWidgetCtrl<C, LdWidget<C, W>>, W extends LdWidget<C, W>>
extends  StatefulWidget 
with LdTagMixin {
  // 🧩 MEMBRES ------------------------
  /// Vista on pertany el wdiget.
  final LdView _view;

  /// Instància del controlador del widget.
  final OnlyOnce<C> _ctrl = OnlyOnce<C>();

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LdWidget({ super.key, required LdView pView, String? pTag })
  : _view = pView {
    (pTag != null) 
        ? set(pTag) 
        : set("${baseTag()}_${LdTagBuilder.newWidgetId}}");
    LdBindings.set(tag, pInst: this);
  }
 
  @override
  void dispose() {
    LdBindings.remove(tag);
  }

  // 🪟 GETTERS I SETTERS --------------
    /// Retorna la vista on pertany el widget.
    LdView get view => _view;

  /// Retorna la vista on pertany el widget.
  C get wCtrl => _ctrl.get(pError: "El controlador del widget encara no s'ha assignat!");

  /// Estableix la vista on pertany el widget.
  set wCtrl(C pCtrl) => _ctrl.set(pCtrl, pError: "El controlador del widget ja estava assignat!");
}

