// ld_view.dart
// Abstracció d'una pàgina de l'aplicació.
// La V de Model-View-Control.
// CreatedAt: 2025/04/07 dl. JIQ

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ld_wbench5/03_core/app/sabina_app.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_view_intf.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'ld_view_ctrl.dart';
import 'ld_view_model.dart';

export 'ld_view_ctrl.dart';
export 'ld_view_model.dart';

/// Abstracció d'una pàgina de l'aplicació.
abstract   class LdView
extends    StatefulWidget
implements LdViewIntf {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdView";
  
  // 🧩 MEMBRES ------------------------
  /// Aplicació on pertany la vista.
  final OnceSet<SabinaApp> _app = OnceSet<SabinaApp>();

  /// Subscripció als missatges de l'stream de l'aplicació.
  StreamSubscription<StreamEnvelope<LdModel>>? _appSub;

  /// Model de la vista.
  final OnceSet<LdViewModel> _model = OnceSet<LdViewModel>();
  
  /// Controlador de la vista.
  final OnceSet<LdViewCtrl>  _ctrl  = OnceSet<LdViewCtrl>();

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LdView({ 
    super.key, 
    String? pTag,
    required SabinaApp pApp }) 
  { _app.set(pApp);
    registerTag(pTag: pTag, pInst: this);
    _appSub = _app.get().subscribe(pLstn: listened, pOnDone: onDone, pOnError: onError);
  }

  /// Allibera els recursos adquirits.
  @override
  void dispose() {
    _app.get().unsubscribe(_appSub);
  }

  // 🪟 GETTERS I SETTERS --------------
  /// 📍 'LdViewIntf': Retorna la instància de l'aplicació on pertany la vista.
  @override SabinaApp get app => _app.get();

  /// 📍 'LdViewIntf': Estableix la instància de l'aplicació on pertany la vista.
  @override set app(SabinaApp pApp) => _app.set(pApp);

  /// 📍 'LdViewIntf': Retorna l'oidor d'stream de la vista.
  @override StreamSubscription<StreamEnvelope<LdModel>>? get appSub => _appSub;

  /// 📍 'LdViewIntf': Estableix l'oidor d'stream de la vista.
  @override set appSub(StreamSubscription<StreamEnvelope<LdModel>>? pAppSub) => _appSub = pAppSub;	


  /// 📍 'LdViewIntf': Retorna el model de la vista.
  @override LdViewModel get vModel => _model.get();       // pError: "El model de la vista $tag encara no ha estat assignat!");

  /// 📍 'LdViewIntf': Estableix el model de la vista.
  @override set vModel(LdViewModel pModel) => _model.set(pModel); // pError: "El model de la vista $tag ja ha estat assignat!");

  /// 📍 'LdViewIntf': Retorna el controlador de la vista.
  @override LdViewCtrl get vCtrl => _ctrl.get();         // pError: "El controlador de la vista $tag encara no ha estat assignat!");

  /// 📍 'LdViewIntf': Estableix el controlador de la vista.
  @override set vCtrl(LdViewCtrl pCtrl) => _ctrl.set(pCtrl);    // pError: "El controlador de la vista $tag ja ha estat assignat!");
}
