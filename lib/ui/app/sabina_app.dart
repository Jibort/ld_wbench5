// sabina_app.dart
// Widget principal de l'aplicació.
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/ui/app/sabina_app_ctrl.dart';
import 'package:ld_wbench5/ui/app/sabina_app_model.dart';

/// Widget principal de l'aplicació.
class   SabinaApp 
extends StatefulWidget 
with    LdTaggableMixin {
  /// Instància singleton
  static final SabinaApp _inst = SabinaApp._();
  static SabinaApp get s => _inst;
  
  /// Controlador del widget principal de l'aplicació.
  late final SabinaAppCtrl _ctrl;
  /// Retorna el model del widget principal de l'aplicació.
  SabinaAppCtrl get wCtrl => _ctrl;
  
  /// Model del widget principal de l'aplicació.
  late final SabinaAppModel _model;
  /// Retorna el model del widget principal de l'aplicació.
  SabinaAppModel get wModel => _model;

  /// Constructor privat
  SabinaApp._() {
    tag = className;
    _model = SabinaAppModel(MapDyns(), pApp: this);
    _ctrl = SabinaAppCtrl(pApp: this);
  }
  
  @override
  State<SabinaApp> createState() => _ctrl;
}
