// lang_changed_event.dart
// Event de canvi d'idioma.
// CreatedAt: 2025/04/19 ds. JIQ

import 'package:flutter/rendering.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';

/// Event de canvi d'idioma.
class   LangChangedEvent 
extends StreamEnvelope<LdModel> {
  // 📐 FUNCIONALITAT ESTÀTICA ---------
  static StreamEnvelope<LdModel> envelope({
    required String  pSrc,
    List<String>?    pTgts,
    required Locale? pOldLocale,
    required Locale  pNewLocale,
     })
  => LangChangedEvent(
    pSrc: pSrc, 
    pTgts: pTgts, 
    oldLocale: pOldLocale,
    newLocale: pNewLocale,
  );

  // 🧩 MEMBRES ------------------------
  final Locale? oldLocale;
  final Locale  newLocale;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LangChangedEvent({ 
    required super.pSrc, 
    super.pTgts,
    this.oldLocale,
    required this.newLocale 
  });  
}