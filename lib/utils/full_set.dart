// full_set.dart
// Eina que assegura que la instància que acull sempre es pot modificar.
// Created: 2025/04/07 dl. JIQ

// Eina que assegura que la instància que acull sempre es pot modificar.
import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/L10n/string_tx.dart';

class FullSet<T> {
  // 🧩 MEMBRES ------------------------
  T? _inst;
  @protected T? get i => get(pError: "Error en recuperació de FullSet.StringTx!", pCouldBeNull: _isNullable);
  bool _isSet      = false;
  bool _isNullable = true;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  FullSet({ T? pInst, bool pIsNullable = true }) {
    assert(pInst != null || pIsNullable, "No es pot crear aquesta instància FullSet amb null!");
    _inst = pInst;
    _isNullable = pIsNullable;
    _isSet = (_inst != null && pInst !is StringTx);
  }

  // 🪟 GETTERS I SETTERS --------------
  bool get isSet      => _isSet;
  bool get isNullable => _isNullable;

  T? get({ String? pError, pCouldBeNull = true }) {
    assert(_isSet, pError?? "FullSet: La instància no ha estat encara assignada!");
    assert(pCouldBeNull, "FullSet: La instància no pot ser nul·la en llegir-la!");
    return _inst;
  }

  void set(T? pValue) {
    assert(pValue != null || _isNullable, "No es pot assignar null a aquest OnceSet!");
    _inst = pValue;
    _isSet = true;
  }
}
