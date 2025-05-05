// lib/utils/str_full_set.dart
// Extensió de 'FullSet' per a especialitzar-se en tipus StringTx.
// Created: 2025/05/04 dg. JIQ

import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/full_set.dart';

/// Extensió de 'FullSet' per a especialitzar-se en tipus StringTx.
class StrFullSet
extends FullSet<StringTx> {
  /// Retorna la instància directament com a StringTx.
  @override StringTx? get inst => super.inst;
  
  /// Constructors.
  StrFullSet({ String? pStrOrKey, super.pIsNullable })
  : super(pInst: StringTx(pStrOrKey));

  /// Cert només si el contingut del StringTx és nul.
  @override bool get isNull
  => (inst == null || inst!.isNull);

  /// Retorna el text de la instància.
  String? get t
  => (!isNull)
    ? inst!.text
    : null;

  /// Estableix el text de la instància.
  set t(String? pTextOrKey) 
  => (pTextOrKey != null || isNullable)
    ? (){ inst!.set(pTextOrKey); isSet = true; }()
    : Debug.fatal("No es pot assignar null a aquest FullSet!");
}
