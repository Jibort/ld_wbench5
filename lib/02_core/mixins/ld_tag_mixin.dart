// ld_tag_mixin.dart
// Mixin per a afegir capacitats d'identificació única i cerca de dependències.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:ld_wbench5/02_core/interfaces/ld_disposable_intf.dart';
import 'package:ld_wbench5/10_tools/only_once.dart';

/// Mixin per a afegir capacitats d'identificació i cerca de dependències.
mixin LdTagMixin
implements LdDisposableIntf {
  // 🧩 MEMBRES ------------------------
  final OnlyOnce<String> _tag = OnlyOnce<String>();

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna el tag únic de l'objecte.
  String get tag => _tag.get(pError: "El tag de l'objecte encara no s'ha assignat!");

  /// Estableix el tag únic de l'objecte.
  set (String pTag) => _tag.set(pTag, pError: "El tag de l'objecte ja estava assignat!");

  /// Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  String baseTag();
}