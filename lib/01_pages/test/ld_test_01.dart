// ld_test_01.dart
// Pantalla de proves número 01.
// CreatedAt: 2025/04/08 dt. JIQ

import 'package:ld_wbench5/01_pages/test/ld_test_01_ctrl.dart';
import 'package:ld_wbench5/01_pages/test/ld_test_01_model.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

export 'package:ld_wbench5/01_pages/test/ld_test_01_ctrl.dart';
export 'package:ld_wbench5/01_pages/test/ld_test_01_model.dart';

class LdTest01
extends LdView<LdTest01Ctrl, LdTest01, LdTest01Model> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdTest01";
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdTest01({ 
    super.key,
    required super.pApp,
    super.pTag,
    String? pTitle, 
    String? pSubTitle })
    : super(pModel: LdTest01Model(
      pTitle:    pTitle,
      pSubtitle: pSubTitle))
    { model.view = this;
      ctrl = LdTest01Ctrl(
        pView: this,
        pTag: LdTagBuilder.newCtrlTag(LdTest01Ctrl.className),
      );
      model.vCtrl = ctrl;
    }

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 'LdTagMixin': Retorna la base del tag de la pàgina 'LdTest01'.
  @override String baseTag() => LdTest01.className;

  /// 'StatefulWidget': Retorna el controlador 'State' de la vista.
  @override
  LdTest01Ctrl createState() => ctrl;

  @override
  void listened(StreamEnvelope<LdModel> pEnv) {
    if (pEnv.tgtTags.isEmpty || pEnv.tgtTags.contains(tag)) {
      Debug.info("${tag}listened(pEnv): iniciat ...");

      Debug.info("${tag}listened(pEnv): ... acabat");
    }
  }

  @override
  void onDone() {
    Debug.info("${tag}_onDone(): executat!");
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    String msg = "${tag}_onError(...): ${error.toString()} en: \b ${stackTrace.toString()}";
    Debug.error(msg, Exception(msg));    
  }
}
