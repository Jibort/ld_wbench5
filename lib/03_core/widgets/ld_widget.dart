// ld_widget.dart
// Abstracció de tots els widgets fets servir per l'aplicació.
// CreatedAt 2025/04/13 dl. JIQ

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';

import 'ld_widget_ctrl.dart';
import 'ld_widget_model.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_widget_intf.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

export 'ld_widget_ctrl.dart';
export 'ld_widget_model.dart';

/// Abstracció de tots els widgets fets servir per l'aplicació.
abstract   class LdWidget
extends    StatefulWidget 
with       LdTagMixin
implements LdWidgetIntf {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdWidget";
  
  // 🧩 MEMBRES ------------------------
  /// Vista on pertany el wdiget.
  final LdView _view;

  /// Subscripció als missatges de l'stream de l'aplicació.
  StreamSubscription<StreamEnvelope<LdModel>>? _appSub;

  /// Instància del controlador del widget.
  final OnceSet<LdWidgetCtrl> _ctrl = OnceSet<LdWidgetCtrl>();

  /// Model de dades del widget.
  final OnceSet<LdWidgetModel>  _model = OnceSet<LdWidgetModel>();

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LdWidget({ super.key, required LdView pView, String? pTag })
  : _view  = pView {
    registerTag(pTag: pTag, pInst: this);
    _appSub = _view.subscribe(pLstn: listened, pOnDone: onDone, pOnError: onError);
  }
 
  /// Allibera els recursos adquirits.
  @override
  void dispose() {
    _view.unsubscribe(_appSub);
    super.dispose();
  }

  // 🪟 GETTERS I SETTERS --------------
    /// Retorna la vista on pertany el widget.
    @override LdView get view => _view;

  /// Retorna la vista on pertany el widget.
  @override LdWidgetCtrl get wCtrl => _ctrl.get(pError: "El controlador del widget encara no s'ha assignat!");

  /// Estableix la vista on pertany el widget.
  @override set wCtrl(LdWidgetCtrl pCtrl) => _ctrl.set(pCtrl, pError: "El controlador del widget ja estava assignat!");

  /// Retorna el model de dades que pertany el widged.
  @override LdWidgetModel get wModel => _model.get(pError: "El model del widget encara no s'ha assignat!");

  /// Estableix el model de dades que pertany el widged.
  @override set wModel(LdWidgetModel pModel) => _model.set(pModel, pError: "El model del widget ja estava assignat!");

  // ⚙️📍 FUNCIONALITAT ABSTRACTA ------
  /// Unica funcionalitat d'obligada implementació des de StatefulWidget.
  @override State<StatefulWidget> createState();
}

  


