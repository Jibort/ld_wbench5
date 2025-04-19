// full_set.dart
// Eina que assegura que la instància que acull sempre es pot modificar.
// CreatedAt: 2025/04/07 dl. JIQ

// Eina que assegura que la instància que acull sempre es pot modificar.
class FullSet<T> {
  // 🧩 MEMBRES ------------------------
  T? _inst;
  bool _isSet = false;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  FullSet({ T? pInst }) {
    _inst = pInst;
    _isSet = (_inst != null);
  }

  // 🪟 GETTERS I SETTERS --------------
  bool get isSet => _isSet;

  T? get({ String? pError }) {
    assert(_isSet, pError?? "La instància no ha estat encara assignada!");
    return _inst;
  }

  void set(T? pValue) {
    _inst = pValue;
    _isSet = true;
  }
}
