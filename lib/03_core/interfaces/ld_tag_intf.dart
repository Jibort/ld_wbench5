// ld_tag_mixin.dart
// Mixin per a incorporar capacitats d'identificació única i cerca de dependències.
// CreatedAt: 2025/04/15 dt. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_disposable_intf.dart';
import 'package:ld_wbench5/03_core/ld_bindings.dart';

/// Mixin per a incorporar capacitats d'identificació única i cerca de dependències.
abstract class LdTagIntf
extends  LdDisposableIntf {
  // 🪟 GETTERS I SETTERS --------------
  /// Retorna el tag únic de l'objecte.
  String get tag;

  /// Estableix el tag únic de l'objecte.
  set tag(String pTag);

  // REGISTRE DEL 'tag' ---------------
  /// Registra la instància corresponent al 'tag'.
  registerTag<T extends LdTagIntf>({ required String? pTag, required T pInst });

  /// Assegura que durant l'alliberament de recursos s'elimina la instància pel seu 'tag'.
  @override
  @mustCallSuper
  void dispose() {
    LdBindings.remove(tag);
  }
  
  /// 📍 Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  String baseTag();
}