// lib/utils/str_once_set.dart
// Extensió de 'OnceSet' per a especialitzar-se en tipus StringTx.
// Created: 2025/05/04 dg. JIQ

import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/utils/once_set.dart';

/// Extensió de 'OnceSet' per a especialitzar-se en tipus StringTx.
class StrOnceSet
extends OnceSet<StringTx> {
    /// Constructors.
  StrOnceSet({ String? pStr, super.pIsNullable })
  : super(pInst: StringTx(pStr));

  /// Retorna el text de la instància.
  String? get t => i!.text;

  /// Estableix el text de la instància.
  set t(String? pText) => i!.set(pText);
}
