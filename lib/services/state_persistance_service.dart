// lib/services/state_persistence_service.dart
// Servei centralitzat de persistència d'estat per widgets i pàgines
// Created: 2025/05/19 dg. CLA

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Servei per a la persistència d'estat entre reconstruccions d'UI
class StatePersistenceService {
  // MEMBRES ESTÀTICS =====================================
  /// Instància singleton
  static final StatePersistenceService _inst = StatePersistenceService._();
  
  /// Retorna la instància estàtica
  static StatePersistenceService get s => _inst;
  
  // MEMBRES ==============================================
  /// Mapa global per desar l'estat
  final MapDyns _persistentState = MapDyns();
  
  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Constructor privat
  StatePersistenceService._() {
    Debug.info("StatePersistenceService: Servei inicialitzat");
  }
  
  // GETTERS/SETTERS ======================================
  /// Obté un valor desat, o el valor per defecte si no existeix
  T? getValue<T>(String pKey, [T? pDefaultValue]) {
    final value = _persistentState[pKey];
    if (value != null && value is T) {
      return value;
    }
    return pDefaultValue;
  }
  
  /// Desa un valor associat a una clau
  void setValue<T>(String pKey, T? pValue) {
    _persistentState[pKey] = pValue;
    Debug.info("StatePersistenceService: Valor per a '$pKey' desat");
  }
  
  /// Comprova si existeix un valor per a una clau
  bool hasValue(String pKey) {
    return _persistentState.containsKey(pKey) && _persistentState[pKey] != null;
  }
  
  /// Elimina un valor
  void removeValue(String pKey) {
    _persistentState.remove(pKey);
    Debug.info("StatePersistenceService: Valor per a '$pKey' eliminat");
  }
  
  /// Neteja tots els valors
  void clear() {
    _persistentState.clear();
    Debug.info("StatePersistenceService: Tots els valors eliminats");
  }
  
  /// Estableix un valor només si no existeix
  void setValueIfAbsent<T>(String pKey, T pValue) {
    if (!hasValue(pKey)) {
      setValue(pKey, pValue);
      Debug.info("StatePersistenceService: Valor per defecte per a '$pKey' establert");
    }
  }
  
  /// Retorna un mapa amb tots els valors actualment desats
  /// Només per a depuració, no utilitzar per a operacions regulars
  MapDyns getDebugMap() {
    return MapDyns.from(_persistentState);
  }
  
  /// Crea una clau per a un tag i un camp específic
  static String makeKey(String pTag, String pField) {
    return "${pTag}_$pField";
  }
}