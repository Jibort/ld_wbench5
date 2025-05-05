// test_page.dart
// Pàgina de prova que mostra la implementació simplificada
// Created: 2025/04/29 DT. CLA[JIQ]

import 'test_page_model.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/ui/pages/test_page/test_page_ctrl.dart';

export 'test_page_ctrl.dart';
export 'test_page_model.dart';

/// Pàgina de prova que mostra la nova arquitectura simplificada
class   TestPage
extends LdPageAbs {
  /// Constructor
  TestPage({
    super.key, 
    super.pTag, 
    required String pTitleKey, 
    String? pSubTitleKey }) 
  { vCtrl = TestPageCtrl(pPage: this);
    vModel = TestPageModel(
      pPage: this,
      pTitleKey: pTitleKey,
      pSubTitleKey: pSubTitleKey
    );
  }
}

