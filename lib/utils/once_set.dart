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
  @protected T? get inst => _inst;

  bool _isSet      = false;
  bool _isNullable = true;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
    OnceSet({ T? pInst, bool pIsNullable = true }) {
    _inst = pInst;
    _isNullable = pIsNullable;
    // Només comprovem si s'ha donat un valor inicial
    if (pInst != null && (pInst is! StringTx || !(pInst as StringTx).isNull)) {
      _isSet = true;
    } else {
      _isSet = false;
      // No validem nul·labilitat aquí, només al set() i get()
    }
  }

  // 🪟 GETTERS I SETTERS --------------
  bool get isSet      => _isSet;
  set isSet(bool pIsSet) => _isSet = true;
  bool get isNullable => _isNullable;
  bool get isNull     => (_inst == null);
  
  T? get({ String? pError }) {
    assert(
      _isSet, 
      pError?? "OnceSet: La instància NO ha estat inicialitzada!"
    );
    assert(
      (_isNullable || _inst != null), 
      "OnceSet: La instància no pot ser nul·la en llegir-la!"
    );
    return _inst;
  }

  void set(T? pValue, { String? pError }) {
    assert(!_isSet, pError?? "Error en assignació 'OnceSet'!");
    
    // Comprovació addicional per a StringTx
    assert(
      (pValue != null || _isNullable) && 
      (pValue is! StringTx || !(pValue as StringTx).isNull || _isNullable),
      "No es pot assignar null a aquest OnceSet!"
    );
    
    _inst = pValue;
    _isSet = true;
  }
}
