// ld_widget_abs.dart
// Abstracció d'un widget de l'aplicació.
// CreatedAt: 2025/04/17 dj. JIQ

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ld_wbench5/03_core/abstraction/ld_view_abs.dart';
import 'package:ld_wbench5/03_core/listeners/view_listener.dart';
import 'package:ld_wbench5/03_core/streams/import.dart';
import 'package:ld_wbench5/03_core/tag/ld_tag_mixin.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget_model_abs.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Abstracció d'un widget de l'aplicació.
abstract class LdWidgetAbs
extends  StatefulWidget
with     LdTagMixin,
         StreamReceiverMixin
implements ViewListenerIntf {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdWidgetAbs";

// 🧩 MEMBRES ------------------------
  /// Vista on pertany el wdiget.
  final LdViewAbs _view;

  /// Controlador del widget.
  final OnceSet<LdWidgetCtrlAbs> _wCtrl = OnceSet<LdWidgetCtrlAbs>();

  /// Model del widget.
  final OnceSet<LdWidgetModelAbs> _wModel = OnceSet<LdWidgetModelAbs>();


  /// Subscripció als events de l'Stream de la vista.
  LdStreamListenerAbs? _viewSub;


  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  /// Constructor base per a 'LdWidgetAbs'.
  LdWidgetAbs({ super.key, required LdViewAbs pView, String? pTag })
  : _view = pView 
  { registerTag(pTag: pTag, pInst: this);
    _viewSub = ViewStreamListener(pLstn: this);
  }

  /// Desconnecta els oïdors a Streams i allibera els recursos fets servir.
  @override void dispose() {
    _viewSub?.dispose();
    super.dispose();
  }

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista on pertany el widget.
  LdViewAbs get view => _view;

  /// Retorna el controlador del widget.
  LdWidgetCtrlAbs get wCtrl => _wCtrl.get();

  /// Estableix el controlador del widget.
  set wCtrl(covariant LdWidgetCtrlAbs pCtrl) => _wCtrl.set(pCtrl);

  /// Retorna el model de dades que pertany el widged.
  LdWidgetModelAbs get wModel => _wModel.get();

  /// Estableix el model de dades que pertany el widged.
  set wModel(covariant LdWidgetModelAbs pModel) => _wModel.set(pModel);

  /// Retorna la subscripció de la vista a l'stream de l'aplicació.
  StreamSubscription<StreamEvent>? get vSub => _viewSub?.sub as StreamSubscription<StreamEvent>;

  /// Estableix la subscripció de la vista a l'stream de l'aplicació.
  set vSub(StreamSubscription<StreamEvent>? pViewSub) => (pViewSub != null) ? _viewSub?.sub = pViewSub: null;

  // ⚙️📍 GESTIÓ D'EVENTS D'STREAMS ----
  /// 📍 'ViewListenerIntf': Gestió dels events de l'Stream de la vista.
  @override listenViewEvent(covariant StreamEvent pEnv);

  /// 'ViewListenerIntf': Gestió dels errors a l'Stream de la vista.
  @override onViewStreamError(Object pError, StackTrace pTrace);

  /// Gestió ??? a l'Stream de la vista.
  @override onViewStreamDone();
}