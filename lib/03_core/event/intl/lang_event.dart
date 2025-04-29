// lang_event.dart
// Model de representació de l'event de canvi de llengua al UI.
// CreatedAt: 2025/04/19 ds. JIQ

import 'package:ld_wbench5/03_core/model/ld_model_abs.dart';
import 'package:ld_wbench5/03_core/event/stream/stream_event.dart';

export 'package:ld_wbench5/03_core/event/intl/lang_event_model.dart';

// Model de representació de l'event de canvi de llengua al UI.
class   LangEvent 
extends StreamEventWModel {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LangEvent";
  
  // 📐 FUNCIONALITAT ESTÀTICA ---------
  static StreamEvent envelope({
    required String pSrc,
    List<String>? pTgts,
    required LdModelAbs pCause })
  => LangEvent(pSrc: pSrc, pTgts: pTgts, pModel: pCause);

  // 🧩 MEMBRES ------------------------

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LangEvent({ 
    required super.pSrc, 
    super.pTgts,
    required super.pModel
  });
  
  // 🪟 GETTERS I SETTERS --------------
  @override String get instClassName => className;
  LdModelAbs? get cause => model;
}