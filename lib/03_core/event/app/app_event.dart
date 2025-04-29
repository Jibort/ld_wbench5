// app_event.dart
// Event general d'informació d'accions sobre l'aplicació
// CreatedAt: 2025/04/24 dj. JIQ

import 'package:ld_wbench5/03_core/streams/import.dart';

/// Event general d'informació d'accions sobre l'aplicació.
class AppEvent
extends StreamEventWModel {
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  AppEvent({
    required super.pSrc,
    super.pTgts,
    required super.pModel });
}