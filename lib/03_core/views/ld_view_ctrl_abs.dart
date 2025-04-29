// ld_view_ctrl.dart
// Abstracció del controlador per a una pàgina de l'aplicació.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:flutter/material.dart';

import 'package:ld_wbench5/03_core/tag/ld_tag_mixin.dart';
import 'package:ld_wbench5/03_core/views/ld_view_model_abs.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_ctrl_intf.dart';
import 'package:ld_wbench5/03_core/abstraction/ld_view_abs.dart';
import 'package:ld_wbench5/10_tools/debug.dart';
import 'package:ld_wbench5/10_tools/full_set.dart';

/// Abstracció del controlador per a una pàgina de l'aplicació.
abstract class LdViewCtrlAbs
extends    State<LdViewAbs>
with       LdTagMixin
implements LdCtrlIntf<LdViewAbs> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdViewCtrlAbs";
  
  // 🧩 MEMBRES ------------------------
  final FullSet<LdViewAbs> _view = FullSet<LdViewAbs>();

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor base per a la classe.
  LdViewCtrlAbs({
    required LdViewAbs pView,
    String? pTag })
  { _view.set(pView);
    registerTag(pTag: pTag, pInst: this);
  }

  /// 📍 'LdCtrlIntf': Es crida quan s'ha d'allibera l'objecte.
  @override 
  @mustCallSuper
  void onDispose() {
    Debug.info("$tag.onDispose(): Executat!");
  }

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista on pertany el controlador.
  LdViewAbs get view => _view.get()!;
  /// Estableix la vista on pertany el controlador.
  set view(LdViewAbs pView) => _view.set(pView);

  /// Retorna el model de la vista on pertany el controlador.
  LdViewModelAbs get model => view.vModel;
  
  // ♻️ CLICLE DE VIDA ----------------
  /// 📍 'State': Called when this object is inserted into the tree.
  @override
  void initState() {
    onInitState();
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
  void didUpdateWidget(LdViewAbs pOldWidget) {
    super.didUpdateWidget(pOldWidget);
    onInstanceUpdated(pOldWidget);
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

