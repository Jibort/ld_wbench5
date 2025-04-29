// rebuild_event.dart
// Model de representació de l'event de canvi de tema visual.
// CreatedAt: 2025/04/19 ds. JIQ

import 'package:ld_wbench5/03_core/event/stream/stream_event.dart';

/// Model de representació de l'event de canvi de tema visual.
class   RebuildEvent
extends StreamEvent {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "RebuildEvent";
  
  // 📐 FUNCIONALITAT ESTÀTICA ---------
  static StreamEvent envelope({
    required String pSrc,
    List<String>? pTgts })
  => RebuildEvent(pSrc: pSrc, pTgts: pTgts);

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  RebuildEvent({ 
    required super.pSrc, 
    super.pTgts });
  
  // 🪟 GETTERS I SETTERS --------------
  @override String get instClassName => className;

}