// once_set.dart
// Eina que assegura que la instància que acull només s'inicia un cop.
// CreatedAt: 2025/04/07 dl. JIQ

/// Eina que assegura que la instància que acull només s'inicia un cop
/// independentment si s'inicialitza com a nul.
class OnceSet<T> {
  // 🧩 MEMBRES ------------------------
  T? _inst;
  bool isSet = false;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  OnceSet({ T? pInst }) {
    _inst = pInst;
    isSet = (_inst != null);
  }

  // 🪟 GETTERS I SETTERS --------------
  T get({ String? pError }) {
    assert(isSet, pError?? "Error en recuperació 'OnceSet'!");
    return _inst!;
  }

  void set(T pValue, { String? pError }) {
    assert(!isSet, pError?? "Error en assignació 'OnceSet'!");
    _inst = pValue;
    isSet = true;
  }
}
