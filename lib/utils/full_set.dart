// full_set.dart
// Eina que assegura que la instància que acull sempre es pot modificar.
// Created: 2025/04/07 dl. JIQ

// Eina que assegura que la instància que acull sempre es pot modificar.
class FullSet<T> {
  // 🧩 MEMBRES ------------------------
  T? _inst;
  bool _isSet      = false;
  bool _isNullable = true;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  FullSet({ T? pInst, bool pIsNullable = true }) {
    assert(pInst != null || pIsNullable, "No es pot crear aquesta instància FullSet amb null!");
    _inst = pInst;
    _isNullable = pIsNullable;
    _isSet = (_inst != null);
  }

  // 🪟 GETTERS I SETTERS --------------
  bool get isSet => _isSet;
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
