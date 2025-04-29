// lang_changed_event.dart
// Event de canvi d'idioma.
// CreatedAt: 2025/04/19 ds. JIQ

import 'package:flutter/rendering.dart';
import 'package:ld_wbench5/03_core/event/intl/lang_event_model.dart';
import 'package:ld_wbench5/03_core/event/stream/stream_event.dart';

/// Event de canvi d'idioma.
class   LangChangedEvent 
extends StreamEventWModel {
  // 📐 FUNCIONALITAT ESTÀTICA ---------
  static StreamEvent envelope({
    required String  pSrc,
    List<String>?    pTgts,
    required Locale? pOldLocale,
    required Locale  pNewLocale,
     })
  => LangChangedEvent(
    pSrc: pSrc, 
    pTgts: pTgts, 
    pOldLocale: pOldLocale,
    pNewLocale: pNewLocale,
  );

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LangChangedEvent({ 
    required super.pSrc, 
    super.pTgts,
    Locale? pOldLocale,
    required Locale pNewLocale })
  : super(pModel: LangEventModel(pOld: pOldLocale, pNew: pNewLocale));  
}