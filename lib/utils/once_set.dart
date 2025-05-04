// once_set.dart
// Eina que assegura que la instància que acull només s'inicia un cop.
// Created: 2025/04/07 dl. JIQ



import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/L10n/string_tx.dart';

/// Eina que assegura que la instància que acull només s'inicia un cop
/// independentment si s'inicialitza com a nul.
class OnceSet<T> {
  // 🧩 MEMBRES ------------------------
  T? _inst;
  @protected T? get i => get(pError: "Error en recuperació de OnceSet.StringTx!", pCouldBeNull: _isNullable);
  bool _isSet      = false;
  bool _isNullable = true;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  OnceSet({ T? pInst, bool pIsNullable = true }) {
    assert(pInst != null || pIsNullable, "No es pot crear aquesta instància OnceSetSet amb null!");
    _inst = pInst;
    _isNullable = pIsNullable;
    _isSet = (_inst != null && pInst !is StringTx);
  }

  // 🪟 GETTERS I SETTERS --------------
  bool get isSet      => _isSet;
  bool get isNullable => _isNullable;
  
  T? get({ String? pError, pCouldBeNull = true }) {
    assert(_isSet, pError?? "OnceSet: La instància no ha estat encara assignada!");
    assert(_inst != null || _isNullable, "OnceSet: La instància no pot ser nul·la en llegir-la!");
    return _inst;
  }

  void set(T? pValue, { String? pError }) {
    assert(!_isSet, pError?? "Error en assignació 'OnceSet'!");
    assert(pValue != null || _isNullable, "No es pot assignar null a aquest OnceSet!");
    _inst = pValue;
    _isSet = true;
  }
}
