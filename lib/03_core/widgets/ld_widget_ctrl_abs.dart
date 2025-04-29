// ld_widget_ctrl_abs.dart
// Abstracció del controlador per a un widget de l'aplicació.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:flutter/material.dart';

import 'ld_widget_model_abs.dart';
import 'package:ld_wbench5/03_core/abstraction/ld_view_abs.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_ctrl_intf.dart';
import 'package:ld_wbench5/03_core/abstraction/ld_widget_abs.dart';
import 'package:ld_wbench5/03_core/tag/ld_tag_mixin.dart';
import 'package:ld_wbench5/03_core/streams/import.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Abstracció del controlador per a un widget de l'aplicació.
abstract class LdWidgetCtrlAbs
extends    State<LdWidgetAbs>
with       LdTagMixin, 
           StreamReceiverWidgetMixin
implements LdCtrlIntf<LdWidgetAbs> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdWidgetCtrl";
  
  // 🧩 MEMBRES ------------------------
  ///Vista on pertany el widget del controlador.
  final OnceSet<LdViewAbs> _view = OnceSet<LdViewAbs>();

  /// Widget on pertany el controlador.
  final OnceSet<LdWidgetAbs> _widget = OnceSet<LdWidgetAbs>();

  /// Retorna cert només si el widget està disponible.
  bool _isEnabled;

  /// Retorna cert només si el wiget és visible.
  bool _isVisible;

  /// Retorna cer si el widget pot capturar el focus.
  bool _isFocusable;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdWidgetCtrlAbs({ 
    required LdViewAbs pView, 
    required LdWidgetAbs pWidget, 
    String? pTag,
    bool isEnabled   = true,
    bool isVisible   = true,
    bool isFocusable = true, })
  : _isEnabled   = isEnabled,
    _isVisible   = isVisible,
    _isFocusable = isFocusable {
      _view.set(pView);
      _widget.set(pWidget);
      registerTag(pTag: pTag, pInst: this);
    }

  @override void dispose() => super.dispose();

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista on pertany el widget.
  LdViewAbs get view => _view.get();

  /// Retorna el Widget on pertany el controlador.
  @override LdWidgetAbs get widget => _widget.get();
  
  /// Actualitza el Widget on pertany el controlador.
  set widget(LdWidgetAbs pWidget)  => _widget.set(pWidget);
  
  /// Retorna el model associat al widget.
  LdWidgetModelAbs get model => widget.wModel;
  
  // 🪟 GETTERS I SETTERS --------------
  bool get isEnabled => _isEnabled;
  set isEnabled(bool pIsEnabled) {
    if (_isEnabled != pIsEnabled) {
      setState(() => _isEnabled = pIsEnabled);
    }
  }

  bool get isVisible => _isVisible;
  set isVisible(bool pIsVisible) {
    if (_isVisible != pIsVisible) {
      setState(()  => _isVisible = pIsVisible);
    }
  }
  
  bool get isFocusable => _isFocusable;
  set isFocusable(bool pIsFocusable) {
    if (_isFocusable != pIsFocusable) {
      setState(()  => _isFocusable = pIsFocusable);
    }
  }

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
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

  @override void setState(void Function() pChanges)  => super.setState(pChanges);
}
