// ld_view_abs.dart
// Abstracció d'una vista de l'aplicació.
// CreatedAt: 2025/04/17 dj. JIQ

import 'package:flutter/material.dart';

import 'package:ld_wbench5/03_core/app/sabina_app.dart';
import 'package:ld_wbench5/03_core/event/app/app_event.dart';
import 'package:ld_wbench5/03_core/event/app/app_event_model.dart';
import 'package:ld_wbench5/03_core/listeners/app_listener.dart';
import 'package:ld_wbench5/03_core/tag/ld_tag_mixin.dart';
import 'package:ld_wbench5/03_core/streams/import.dart';
import 'package:ld_wbench5/03_core/views/ld_view_ctrl_abs.dart';
import 'package:ld_wbench5/03_core/views/ld_view_model_abs.dart';
import 'package:ld_wbench5/10_tools/debug.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Abstracció d'una vista de l'aplicació.
abstract class LdViewAbs
extends    StatefulWidget
with       LdTagMixin, 
           StreamEmitterMixin, 
           StreamReceiverMixin
implements AppListenerIntf {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdViewAbs";

  // 🧩 MEMBRES ------------------------
  /// Aplicació on pertany la vista.
  final OnceSet<SabinaApp> _app = OnceSet<SabinaApp>();
  
  /// Controlador de la vista.
  final OnceSet<LdViewCtrlAbs> _ctrl = OnceSet<LdViewCtrlAbs>();
  final OnceSet<LdViewModelAbs> _model = OnceSet<LdViewModelAbs>();
  /// Subscripció als missatges de l'stream de l'aplicació.
  AppStreamListener? _appSub;
  
  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LdViewAbs({ 
    super.key,
    String? pTag,
    required SabinaApp pApp
     })
  { _app.set(pApp);
    _appSub = AppStreamListener(pLstn: this);
    registerTag(pTag: pTag, pInst: this);
  }

  @override void dispose() {
    _appSub?.dispose();
    super.dispose();
  }

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna l'aplicació on pertany la vista.
  SabinaApp get app => _app.get();

  /// Estableix l'aplicació on pertany la vista.
  set app(SabinaApp pApp) => _app.set(pApp);

  /// Retorna el model de la vista.
  LdViewModelAbs get vModel => _model.get();

  /// Estableix el model de la vista.
  set vModel(LdViewModelAbs pModel) => _model.set(pModel);

  /// Retorna el controlador de la vista.
  LdViewCtrlAbs get vCtrl => _ctrl.get();

  /// Estableix el controlador de la vista.
  set vCtrl(LdViewCtrlAbs pCtrl) => _ctrl.set(pCtrl);

  // ♻️📍 'AppListenerIntf' ====================================================
  /// 📍 'AppListenerIntf': Gestió dels events de l'Stream del gestor d'idiomes.
  @override void listenAppEvent(AppEvent pEnv) {
    if (pEnv.tgtTags.isEmpty || pEnv.tgtTags.contains(tag)) {
      Debug.info("$tag.listenAppEvent(pEnv): executant ...");
      if (pEnv.hasModel) {
        switch (pEnv.model) {
        case AppEventModel _:
          vCtrl.setState(() {}); 
          send(pEnv); // TODO: Realment cal si hem reconstruït tota la vista?
          break;
        } 
      } else {
        switch (pEnv) {
        case RebuildEvent re:
          vCtrl.setState(() {}); 
          send(re); // TODO: Realment cal si hem reconstruït tota la vista?
          break;
        }
      }
      Debug.info("$tag.listenAppEvent(pEnv): ... executat");
    }
  }

  /// 📍 'AppListenerIntf': Gestió dels errors a l'Stream del gestor d'idiomes.
  @override void onAppStreamError(Object pError, StackTrace pSTrace) {
    String msg = "$tag.onAppStreamError(pError, pSTrace ${pError.toString()} en: \b ${pSTrace.toString()}";
    Debug.error(msg, Exception(msg));    
  }

  /// 📍 'AppListenerIntf': Gestió ??? a l'Stream de l'aplicació.
  @override void onAppStreamDone() {
      Debug.info("$tag.onAppStreamDone(): Executat");
  }
}
