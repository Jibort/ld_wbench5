// ld_page.dart
// Pàgina base simplificada per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_page/ld_page_ctrl.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_model.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/utils/once_set.dart';

export 'ld_page_ctrl.dart';
export 'ld_page_model.dart';

/// Pàgina base que proporciona funcionalitats comunes
abstract class LdPageAbs
extends  StatefulWidget
with     LdTaggableMixin {
  // CONTROLADOR ==============================================================
  /// Controlador de la pàgina
  final OnceSet<LdPageCtrl> _ctrl = OnceSet<LdPageCtrl>();
  /// Retorna el controlador de la pàgina.
  LdPageCtrl get vCtrl => _ctrl.get()!;
  /// Estableix el controlador de la pàgina.
  set vCtrl(LdPageCtrl pCtrl) => _ctrl.set(pCtrl);

  // MODEL ====================================================================
  /// Model de dades de la pàgina
  final OnceSet<LdPageModelAbs> _model = OnceSet<LdPageModelAbs>();
  /// Retorna el controlador de la pàgina.
  LdPageModelAbs get vModel => _model.get()!;
  /// Estableix el controlador de la pàgina.
  set vModel(LdPageModelAbs pModel) => _model.set(pModel);

  /// Constructor
  /// Crea una nova pàgina base
  LdPageAbs({
    super.key, 
    String? pTag })
  { 
     tag = (pTag != null) 
      ? pTag
      : className;
    // Ara el controlador el podem assignar des d'on ens vagi millor.
    // ctrl.cPage = this;
  }
  
  @override
  State<LdPageAbs> createState() => _ctrl.get()!;
}
