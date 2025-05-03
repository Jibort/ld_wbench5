// test_page.dart
// Pàgina de prova que mostra la implementació simplificada
// Created: 2025/04/29 DT. CLA[JIQ]


import 'test_page_model.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/pages/test_page/test_page_ctrl.dart';

export 'test_page_ctrl.dart';
export 'test_page_model.dart';

/// Pàgina de prova que mostra la nova arquitectura simplificada
class   TestPage
extends LdPageAbs {
  /// Constructor
  TestPage({super.key}) 
  : super(pTag: 'TestPage')
  { vCtrl = TestPageCtrl(pPage: this);
    vModel = TestPageModel(pPage: this, pTitle: L.sAppSabina.tx, pSubTitle: L.sWelcome.tx);
    // JAB_Q: És suficient amb la crida des del controlador TestPageCtrl?
    // vModel.attachObserver(vCtrl);
  }
}

