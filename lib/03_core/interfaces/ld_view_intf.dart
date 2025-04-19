// ld_view_interface.dart
// Interfície pública d'una vista de l'aplicació.
// CreatedAt: 2025/04/17 dj. JIQ

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/app/sabina_app.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';
import 'package:ld_wbench5/03_core/mixins/stream_emitter_mixin.dart';
import 'package:ld_wbench5/03_core/mixins/stream_receiver_mixin.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';

/// Interfície pública d'una vista de l'aplicació.
abstract class LdViewIntf
extends  StatefulWidget
with     LdTagMixin, 
         StreamEmitterMixin<StreamEnvelope<LdModel>, LdModel>, 
         StreamReceiverMixin<StreamEnvelope<LdModel>, LdModel> {
  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LdViewIntf({ super.key });

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna l'aplicació on pertany la vista.
  SabinaApp get app;

  /// Estableix l'aplicació on pertany la vista.
  set app(SabinaApp pApp);

  /// Retorna el model de la vista.
  LdViewModel get vModel;

  /// Estableix el model de la vista.
  set vModel(LdViewModel pModel);

  /// Retorna el controlador de la vista.
  LdViewCtrl get vCtrl;

  /// Estableix el controlador de la vista.
  set vCtrl(LdViewCtrl pCtrl);

  /// Retorna la subscripció de la vista a l'stream de l'aplicació.
  StreamSubscription<StreamEnvelope<LdModel>>? get appSub;

  /// Estableix la subscripció de la vista a l'stream de l'aplicació.
  set appSub(StreamSubscription<StreamEnvelope<LdModel>>? pAppSub);
}