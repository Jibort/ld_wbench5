// ld_view.dart
// Abstracció d'una pàgina de l'aplicació.
// La V de Model-View-Control.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/02_core/ld_bindings.dart';
import 'package:ld_wbench5/02_core/ld_tag_builder.dart';
import 'package:ld_wbench5/02_core/mixins/ld_tag_mixin.dart';
import 'package:ld_wbench5/02_core/views/ld_view_ctrl.dart';
import 'package:ld_wbench5/02_core/views/ld_view_model.dart';
import 'package:ld_wbench5/10_tools/only_once.dart';

/// Abstracció d'una pàgina de l'aplicació.
abstract class LdView<
  M extends LdViewModel, 
  C extends LdViewCtrl > 
extends  StatefulWidget
with     LdTagMixin {
  // 🧩 MEMBRES ------------------------
  final OnlyOnce<M> _model = OnlyOnce<M>();
  final OnlyOnce<C> _ctrl  = OnlyOnce<C>();

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LdView({ 
    super.key, 
    String? pTag,
    required M pModel }) {
    set("${pTag?? baseTag()}_${LdTagBuilder.newCtrlId}");
    LdBindings.set(tag, pInst: this);
    model = pModel;
  }

  @override
  void dispose() {
    LdBindings.remove(tag);
  }

  // 🪟 GETTERS I SETTERS --------------
  M get model         => _model.get();       // pError: "El model de la vista $tag encara no ha estat assignat!");
  set model(M pModel) => _model.set(pModel); // pError: "El model de la vista $tag ja ha estat assignat!");
  C get ctrl          => _ctrl.get();        // pError: "El controlador de la vista $tag encara no ha estat assignat!");
  set ctrl(C pCtrl)   => _ctrl.set(pCtrl);   // pError: "El controlador de la vista $tag ja ha estat assignat!");
}
