// ld_widget_ctrl.dart
// Abstracció del controlador per a un widget de l'aplicació.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_ctrl_lifecicle.dart';
import 'package:ld_wbench5/03_core/ld_ctrl.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';

/// Abstracció del controlador per a un widget de l'aplicació.
abstract   class LdWidgetCtrl<C extends LdWidgetCtrl<C, W>, W extends LdWidget<C, W>> 
extends    LdCtrl<W>  
implements LdCtrlLifecycleIntf<W> {
  // 🧩 MEMBRES ------------------------
  final LdView  _view;
  W             _widget;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdWidgetCtrl({ required LdView pView, required W pWidget, super.pTag })
  : _widget = pWidget,
    _view   = pView;

  @override
  void dispose() {
    super.dispose();
  }

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista on pertany el widget.
  LdView      get view   => _view;
  @override W get widget => _widget;
  set widget(W pWidget)  => _widget = pWidget;

  /// 📍 'State': Describes the part of the user interface represented by this view.
  @override
  Widget build(BuildContext pBCtx) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onRendered(pBCtx); 
    });

    return buildWidget(pBCtx);
  }

  // ⚙️📍 FUNCIONALITAT ----------------
  /// Creació de tot l'arbre de components del Widget.
  Widget buildWidget(BuildContext pBCtx);
}
