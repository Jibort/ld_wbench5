// ld_test_01.dart
// Pantalla de proves número 01.
// CreatedAt: 2025/04/08 dt. JIQ

import 'dart:async';

import 'package:ld_wbench5/03_core/interfaces/ld_tag_intf.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';
import 'package:ld_wbench5/03_core/mixins/stream_emitter_mixin.dart';
import 'package:ld_wbench5/03_core/mixins/stream_receiver_mixin.dart';
import 'package:ld_wbench5/03_core/streams/events/rebuild_event.dart';
import 'package:ld_wbench5/08_theme/events/theme_model.dart';
import 'package:ld_wbench5/09_intl/events/lang_changed_event.dart';

import 'ld_test_01_ctrl.dart';
import 'ld_test_01_model.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

export 'ld_test_01_ctrl.dart';
export 'ld_test_01_model.dart';

class   LdTest01
extends LdView
with    LdTagMixin,
        StreamEmitterMixin<StreamEnvelope<LdModel>, LdModel>,
        StreamReceiverMixin<StreamEnvelope<LdModel>, LdModel>
implements LdTagIntf {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdTest01";
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdTest01({ 
    super.key,
    required super.pApp,
    super.pTag,
    String? pTitle, 
    String? pSubTitle })
  { vModel = LdTest01Model(
    pView:     this,
    pTitle:    pTitle,
    pSubtitle: pSubTitle);
    vCtrl = LdTest01Ctrl(pView: this);
  }

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 'LdTagMixin': Retorna la base del tag de la pàgina 'LdTest01'.
  @override String baseTag() => LdTest01.className;

  /// 'StatefulWidget': Retorna el controlador 'State' de la vista.
  @override
  LdTest01Ctrl createState() => vCtrl as LdTest01Ctrl;

  @override
  void listened(StreamEnvelope<LdModel> pEnv) {
    if (pEnv.tgtTags.isEmpty || pEnv.tgtTags.contains(tag)) {
      Debug.info("${tag}listened(pEnv): iniciat ...");
      if (pEnv.hasModel) {
        switch (pEnv.model) {
        case ThemeEventModel _:
        case LangChangedEvent _:
          send(pEnv);
          break;
        } 
      } else {
        switch (pEnv) {
      case RebuildEvent re:
        send(re);
        break;
      case LangChangedEvent re:
        send(re);
        break;
      }
      }
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

  /// 📍 'LdViewIntf': Estableix l'oidor d'stream de la vista.
  @override set appSub(StreamSubscription<StreamEnvelope<LdModel>>? pAppSub) => appSub = pAppSub;
}
