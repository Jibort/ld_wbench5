// ld_tag_mixin.dart
// Mixin per a incorporar capacitats d'identificació única i cerca de dependències.
// CreatedAt: 2025/04/15 dt. JIQ

import 'package:ld_wbench5/03_core/interfaces/ld_disposable_intf.dart';

/// Mixin per a incorporar capacitats d'identificació única i cerca de dependències.
abstract class LdTagIntf
extends  LdDisposableIntf {
  // 🪟 GETTERS I SETTERS --------------
  /// Retorna el tag únic de l'objecte.
  String get tag;

  /// Estableix el tag únic de l'objecte.
  set tag(String pTag);

  // ⚙️ FUNCIONALITAT -----------------
  /// Registra la instància corresponent al 'tag'.
  registerTag<T extends LdTagIntf>({ required String? pTag, required T pInst });
  
  /// 📍 Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  String baseTag();
}