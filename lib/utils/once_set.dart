// once_set.dart
// Eina que assegura que la instància que acull només s'inicia un cop.
// CreatedAt: 2025/04/07 dl. JIQ

/// Eina que assegura que la instància que acull només s'inicia un cop
/// independentment si s'inicialitza com a nul.
class OnceSet<T> {
  // 🧩 MEMBRES ------------------------
  T? _inst;
  bool _isSet      = false;
  bool _isNullable = true;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  OnceSet({ T? pInst, bool pIsNullable = true }) {
    assert(pInst != null || pIsNullable, "No es pot crear aquesta instància OnceSetSet amb null!");
    _inst = pInst;
    _isNullable = pIsNullable;
    _isSet = (_inst != null);
  }

  // 🪟 GETTERS I SETTERS --------------
  bool get isSet => _isSet;
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
