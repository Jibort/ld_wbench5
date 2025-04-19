// ld_widget_intf.dart
// Interfície pública d'una vista de l'aplicació.
// CreatedAt: 2025/04/17 dj. JIQ


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';
import 'package:ld_wbench5/03_core/mixins/stream_receiver_mixin.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';

/// Interfície pública d'una vista de l'aplicació.
abstract class LdWidgetIntf
extends  StatefulWidget
with     LdTagMixin,
         StreamReceiverMixin<StreamEnvelope<LdModel>, LdModel> {
  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LdWidgetIntf({ super.key });

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista on pertany el widget.
  LdView get view;

  /// Retorna el controlador del widget.
  LdWidgetCtrl get wCtrl;

  /// Estableix el controlador del widget.
  set wCtrl(LdWidgetCtrl pCtrl);

  /// Retorna el model de dades que pertany el widged.
  LdWidgetModel get wModel;

  /// Estableix el model de dades que pertany el widged.
  set wModel(LdWidgetModel pModel);

  /// Retorna la subscripció de la vista a l'stream de l'aplicació.
  StreamSubscription<StreamEnvelope<LdModel>>? get vSub;

  /// Estableix la subscripció de la vista a l'stream de l'aplicació.
  set vSub(StreamSubscription<StreamEnvelope<LdModel>>? pViewSub);

}