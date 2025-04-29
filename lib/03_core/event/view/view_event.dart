// view_event.dart
// Model de representació d'un event provinent d'una vista.
// CreatedAt: 2025/04/19 ds. JIQ

import 'package:ld_wbench5/03_core/event/view/view_event_model.dart';
import 'package:ld_wbench5/03_core/model/ld_model_abs.dart';
import 'package:ld_wbench5/03_core/event/stream/stream_event.dart';

export 'package:ld_wbench5/03_core/event/view/view_event_model.dart';

/// Model de representació d'un event provinent d'una vista.
class   ViewEvent 
extends StreamEventWModel {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "ViewEvent";
  
  // 📐 FUNCIONALITAT ESTÀTICA ---------
  static StreamEvent envelope({
    required String pSrc,
    List<String>? pTgts,
    required ViewEventModel pCause })
  => ViewEvent(pSrc: pSrc, pTgts: pTgts, pModel: pCause);

  // 🧩 MEMBRES ------------------------

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  ViewEvent({ 
    required super.pSrc, 
    super.pTgts,
    required super.pModel
  });
  
  // 🪟 GETTERS I SETTERS --------------
  @override String get instClassName => className;
  LdModelAbs? get cause => model;
}