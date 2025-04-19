// ld_view_ctrl.dart
// Abstracció del controlador per a una pàgina de l'aplicació.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_ctrl_intf.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_view_intf.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';
import 'package:ld_wbench5/10_tools/full_set.dart';
import 'ld_view.dart';

/// Abstracció del controlador per a una pàgina de l'aplicació.
abstract   class LdViewCtrl<W extends LdViewIntf>
extends    State<W>
with       LdTagMixin 
implements LdCtrlIntf {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdViewCtrl";
  
  // 🧩 MEMBRES ------------------------
  final FullSet<LdView> _view = FullSet<LdView>();

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor base per a la classe.
  LdViewCtrl({ required LdView pView, String? pTag }) {
    _view.set(pView);
    registerTag(pTag: pTag, pInst: this);
  }

  /// 📍 'LdCtrlIntf': Es crida quan s'ha d'allibera l'objecte.
  @override 
  @mustCallSuper
  void onDispose() {
    
  }

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista on pertany el controlador.
  LdView get view => _view.get()!;
  /// Estableix la vista on pertany el controlador.
  set view(LdView pView) => _view.set(pView);

  /// Retorna el model de la vista on pertany el controlador.
  LdViewModel get model => view.vModel;
  
  // ♻️ CLICLE DE VIDA ----------------
  /// 📍 'State': Called when this object is inserted into the tree.
  @override
  void initState() {
    onInit();
    super.initState();
  }

  /// 📍 'State': Called when a dependency of this [State] object changes.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onDependenciesResolved();
  }

  /// 📍 'State': Called whenever the widget configuration change.
  @override
  void didUpdateWidget(W pOldWidget) {
    super.didUpdateWidget(pOldWidget);
    onWidgetUpdated(pOldWidget);
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

  @override void setState(void Function() pChanges)  => super.setState(pChanges);
}

