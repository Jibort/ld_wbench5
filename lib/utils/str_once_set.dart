// lib/utils/str_once_set.dart
// Extensió de 'OnceSet' per a especialitzar-se en tipus StringTx.
// Created: 2025/05/04 dg. JIQ

import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/once_set.dart';

/// Extensió de 'OnceSet' per a especialitzar-se en tipus StringTx.
class StrOnceSet
extends OnceSet<StringTx> {
  /// Retorna la instància directament com a StringTx.
  @override StringTx? get inst => super.inst;
  
    /// Constructors.
  StrOnceSet({ String? pStrOrKey, super.pIsNullable })
  : super(pInst: StringTx(pStrOrKey));

  @override bool get isNull => (inst!.isNull);

  /// Retorna el text (clau o literal) de la instància.
  String? get t
  => (isNull)? null : inst!.source;

  /// Retorna el text de la instància.
  String? get tx
  => (!isNull)
    ? inst!.text
    : null;

  /// Estableix el text de la instància.
  set t(String? pTextOrKey) 
  => (!isSet)
    ? (pTextOrKey != null || isNullable)
      ? (){ inst!.set(pTextOrKey); isSet = true; }()
      : Debug.fatal("No es pot assignar null a aquest OnceSet!")
    : Debug.fatal("Ja s'ha assignat un text a aquesta instància!");
}
