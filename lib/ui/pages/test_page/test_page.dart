// test_page.dart
// Pàgina de prova que mostra la implementació simplificada
// Created: 2025/04/29 DT. CLA[JIQ]
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/pages/test_page/test_page_ctrl.dart';

export 'test_page_ctrl.dart';
export 'test_page_model.dart';

/// Pàgina de prova que mostra la nova arquitectura simplificada
class   TestPage
extends LdPageAbs {
  /// Constructor
  TestPage({
    Key? key, 
    super.pTag, 
    required String pTitleKey, 
    String? pSubTitleKey,
    super.pConfig,
  })
  : super(pKey: key) {
    // Afegir la configuració específica d'aquesta pàgina al config existent
    final pageConfig = <String, dynamic>{
      // Configuració del controlador
      cfTitleKey: pTitleKey,
      cfSubTitleKey: pSubTitleKey,
      
      // Dades inicials del model
      mfTitle: pTitleKey,
      mfSubTitle: pSubTitleKey,
      mfCounter: 0,
    };
    
    // Combinar amb la configuració rebuda per paràmetre
    config.addAll(pageConfig);
  }

  /// Constructor alternatiu des d'un mapa de configuració
  TestPage.fromMap(MapDyns config)
    : super(pConfig: config);

  @override
  LdPageCtrlAbs createCtrl() => TestPageCtrl(pPage: this);
}