// ld_view_ctrl.dart
// Abstracció del controlador per a una pàgina de l'aplicació.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_ctrl_lifecicle.dart';
import 'package:ld_wbench5/03_core/ld_ctrl.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/03_core/views/ld_view_model.dart';

/// Abstracció del controlador per a una pàgina de l'aplicació.
abstract class LdViewCtrl<
  C extends LdViewCtrl<C, V, M>, 
  V extends LdView<C, V, M>,
  M extends LdViewModel>  
extends    LdCtrl<V> 
implements LdCtrlLifecycleIntf<V> {
  // 🧩 MEMBRES ------------------------
  V _view;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdViewCtrl({ required V pView, super.pTag })
  : _view = pView;

  /// 📍 'LdCtrlLifecycleIntf': Called when this object is inserted into the tree.
  @override 
  @mustCallSuper
  void onDispose() {
    super.onDispose();
    super.dispose();
  }

  // 🪟 GETTERS I SETTERS --------------
  V get view        => _view;
  set view(V pView) => _view = pView;
  LdViewModel get model  => _view.model;
  LdViewCtrl  get ctrl   => _view.ctrl;

  // ♻️ CLICLE DE VIDA ----------------
  /// 📍 'State': Called when this object is inserted into the tree.
  @override
  void initState() {
    super.initState();
    onInit();
  }

  /// 📍 'State': Called when a dependency of this [State] object changes.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onDependenciesResolved();
  }

  /// 📍 'State': Called whenever the widget configuration change.
  @override
  void didUpdateWidget(covariant V pOldWidget) {
    super.didUpdateWidget(pOldWidget);
    onWidgetUpdated(pOldWidget);
    // Debug.fatal("$tag.didUpdateWidget() No està previst en l'aplicació!", null);
  }

  @override
  void deactivate() {
    onDeactivate();
    super.deactivate();
  }

  /// 📍 'State': Describes the part of the user interface represented by this view.
  @override
  Widget build(BuildContext pBCtx) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onRendered(pBCtx); 
    });

    return buildView(pBCtx);
  }

  // ⚙️📍 FUNCIONALITAT ----------------
  /// Creació de tot l'arbre de components de la pàgina.
  Widget buildView(BuildContext pBCtx);
}

