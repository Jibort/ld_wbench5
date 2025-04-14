// ld_view.dart
// Abstracció d'una pàgina de l'aplicació.
// La V de Model-View-Control.
// CreatedAt: 2025/04/07 dl. JIQ

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/app/sabina_app.dart';
import 'package:ld_wbench5/03_core/ld_bindings.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';
import 'package:ld_wbench5/03_core/mixins/stream_emitter_mixin.dart';
import 'package:ld_wbench5/03_core/mixins/stream_listener_mixin.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/03_core/views/ld_view_ctrl.dart';
import 'package:ld_wbench5/03_core/views/ld_view_model.dart';
import 'package:ld_wbench5/10_tools/only_once.dart';

/// Abstracció d'una pàgina de l'aplicació.
abstract class LdView<
  C extends LdViewCtrl<C, V, M>, 
  V extends LdView<C, V, M>, 
  M extends LdViewModel>
extends  StatefulWidget
with LdTagMixin, 
     StreamEmitterMixin<StreamEnvelope<LdModel>, LdModel>, 
     StreamListenerMixin<StreamEnvelope<LdModel>, LdModel> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdView";
  
  // 🧩 MEMBRES ------------------------
  final SabinaApp _app;
  StreamSubscription<StreamEnvelope<LdModel>>? _appSubs;
  final OnlyOnce<M> _model = OnlyOnce<M>();
  final OnlyOnce<C> _ctrl  = OnlyOnce<C>();

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LdView({ 
    super.key, 
    String?            pTag,
    required SabinaApp pApp,
    required M         pModel })
    : _app = pApp {
      (pTag != null) 
        ? set(pTag) 
        : set("${baseTag()}_${LdTagBuilder.newViewId}}");
      LdBindings.set(tag, pInst: this);
      _appSubs = _app.subscribe(pLstn: listened, pOnDone: onDone, pOnError: onError);
      model = pModel;
    }

  @override
  void dispose() {
    _app.unsubscribe(_appSubs);
    LdBindings.remove(tag);
  }

  // 🪟 GETTERS I SETTERS --------------
  M get model         => _model.get();       // pError: "El model de la vista $tag encara no ha estat assignat!");
  set model(M pModel) => _model.set(pModel); // pError: "El model de la vista $tag ja ha estat assignat!");
  C get ctrl          => _ctrl.get();        // pError: "El controlador de la vista $tag encara no ha estat assignat!");
  set ctrl(C pCtrl)   => _ctrl.set(pCtrl);   // pError: "El controlador de la vista $tag ja ha estat assignat!");
}
