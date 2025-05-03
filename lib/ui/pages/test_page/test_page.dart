// test_page.dart
// Pàgina de prova que mostra la implementació simplificada
// Created: 2025/04/29 DT. CLA[JIQ]

import 'package:ld_wbench5/core/ld_model.dart';
import 'package:ld_wbench5/ui/pages/test_page/test_page_ctrl.dart';

import 'test_page_model.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'test_page_ctrl.dart';
export 'test_page_model.dart';

/// Pàgina de prova que mostra la nova arquitectura simplificada
class      TestPage
extends    LdPageAbs
implements LdModelObserverIntf {
  /// Constructor
  TestPage({super.key}) 
  : super(pTag: 'TestPage')
  { vCtrl = TestPageCtrl(pPage: this);
    vModel = TestPageModel(pTitle: L.sAppSabina.tx);
    vModel.attachObserver(this);

  }
  
  /// 'LdModelObserver': Respon als canvis del model de dades.
  @override
  void onModelChanged(void Function() pfUpdate) {
    Debug.info("$tag.onModelChanged(): executant ...");
    pfUpdate();
    Debug.info("$tag.onModelChanged(): ... executat");
  }
}

