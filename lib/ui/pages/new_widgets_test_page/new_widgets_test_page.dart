// lib/ui/pages/new_widgets_test_page/new_widgets_test_page.dart
// Pàgina de test per validar els nous widgets del projecte Sabina.
// Created: 2025/05/17 ds. GPT(JIQ)

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/ui/pages/new_widgets_test_page/new_widgets_test_page_ctrl.dart';

/// Pàgina de test per validar els nous widgets del projecte Sabina.
class   NewWidgetsTestPage
extends LdPageAbs {
  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Constructor base
  NewWidgetsTestPage({
    Key? key,
    super.pTag,
    required String pTitleKey,
    String? pSubTitleKey,
    super.pConfig,
  }) : super(pKey: key);

  /// Constructor alternatiu des d'un mapa de configuració
  NewWidgetsTestPage.fromMap(MapDyns config)
      : super(pConfig: config);

  // IMPLEMENTACIÓ 'LdPageAbs' ============================
  /// Retorna la instància del controlador de la pàgina.
  @override
  NewWidgetsTestPageCtrl createCtrl() => NewWidgetsTestPageCtrl(pPage: this);
}
