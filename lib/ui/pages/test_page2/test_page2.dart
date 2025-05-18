// lib/ui/pages/test_page2/test_page2.dart
// Pàgina de proves per als widgets del projecte Sabina
// Created: 2025/05/17 ds. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/pages/test_page2/test_page2_ctrl.dart';

export 'package:ld_wbench5/ui/pages/test_page2/test_page2_ctrl.dart';
export 'package:ld_wbench5/ui/pages/test_page2/test_page2_model.dart';

/// Pàgina de proves per als widgets del projecte Sabina
/// 
/// Aquesta pàgina utilitza el component LdFoldableContainer per organitzar
/// les diferents seccions de prova dels widgets.
class TestPage2 extends LdPageAbs {
  /// Constructor
  TestPage2({
    Key? key, 
    super.pTag, 
    required String pTitleKey, 
    String? pSubTitleKey,
    super.pConfig,
  }) : super(pKey: key) {
    // Afegir la configuració específica d'aquesta pàgina al config existent
    final pageConfig = <String, dynamic>{
      // Configuració del controlador
      cfTitleKey: pTitleKey,
      cfSubTitleKey: pSubTitleKey,
      
      // Dades inicials del model
      mfTitle: pTitleKey,
      mfSubTitle: pSubTitleKey,
    };
    
    // Combinar amb la configuració rebuda per paràmetre
    config.addAll(pageConfig);
  }

  /// Constructor alternatiu des d'un mapa de configuració
  TestPage2.fromMap(MapDyns config)
    : super(pConfig: config);

  @override
  LdPageCtrlAbs createCtrl() => TestPage2Ctrl(pPage: this);
}