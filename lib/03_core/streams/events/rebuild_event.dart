// rebuild_event.dart
// Model de representació de l'event de canvi de tema visual.
// CreatedAt: 2025/04/19 ds. JIQ

import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';

/// Model de representació de l'event de canvi de tema visual.
class   RebuildEvent 
extends StreamEnvelope<LdModel> {
  // 📐 FUNCIONALITAT ESTÀTICA ---------
  static StreamEnvelope<LdModel> envelope({
    required String pSrc,
    List<String>? pTgts,
    required LdModel pCause })
  => RebuildEvent(pSrc: pSrc, pTgts: pTgts, cause: pCause);

  // 🧩 MEMBRES ------------------------
  final LdModel cause;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  RebuildEvent({ 
    required super.pSrc, 
    super.pTgts,
    required this.cause });
  
  // 🪟 GETTERS I SETTERS --------------
  
}