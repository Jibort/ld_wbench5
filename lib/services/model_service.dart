// lib/core/services/model_service.dart
// Servei centralitzat d'instàncies de models de dades.
// Created: 2025/05/09 dv. CLA[JIQ]

import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Servei centralitzat d'instàncies de models de dades.
class ModelService {
  /// Instància singleton
  static final ModelService _inst = ModelService._();
  static ModelService get s => _inst;
  
  // Membres de la instància ----------
  /// Map de mapes indexat per ID
  final LdMap<LdMap<dynamic>> _maps = {};
  
  /// Comptador de referències per cada mapa
  final LdMap<int> _refCounts = {};
  
  /// Informació addicional per cada mapa
  final LdMap<String> _mapTypes = {};
  
  // Constructors ---------------------
  /// Constructor privat
  ModelService._() {
    Debug.info("MapManager: Inicialitzant gestor de mapes");
  }

  // Registre, Consulta i Liberació ---
  /// Registra un nou mapa i retorna el seu ID
  /// Si ja existeix un mapa idèntic, retorna l'ID d'aquest
  /// 
  /// [pMap] - El mapa a registrar
  /// [pType] - Tipus del mapa (e.g., "widget", "entity", "config")
  /// [pIdent] - Identificador opcional per ajudar a generar l'ID
  String registerMap(
    LdMap<dynamic> pMap, {
    String pType = "generic",
    String? pIdent,
  }) {
    // Generar un ID per al mapa
    final String mapId = pIdent != null 
        ? "${pType}_${pIdent}_${DateTime.now().millisecondsSinceEpoch}"
        : "${pType}_${DateTime.now().millisecondsSinceEpoch}_${_maps.length}";
    
    // Comprovar si ja existeix un mapa idèntic del mateix tipus
    for (var entry in _maps.entries) {
      if (_mapTypes[entry.key] == pType && _areMapEqual(entry.value, pMap)) {
        // Incrementar el comptador de referències
        _refCounts[entry.key] = (_refCounts[entry.key] ?? 0) + 1;
        Debug.info("MapManager: Reutilitzant mapa existent (ID: ${entry.key}, Tipus: $pType, Refs: ${_refCounts[entry.key]})");
        return entry.key;
      }
    }
    
    // Si no existeix, guardar el mapa
    _maps[mapId] = Map<String, dynamic>.from(pMap);
    _refCounts[mapId] = 1;
    _mapTypes[mapId] = pType;
    
    Debug.info("MapManager: Nou mapa registrat (ID: $mapId, Tipus: $pType)");
    return mapId;
  }
  
  /// Obté el mapa per un ID
  LdMap<dynamic> getMap(String pMapId) {
    assert(_maps.containsKey(pMapId), "Mapa no trobat: $pMapId");
    return _maps[pMapId]!;
  }
  
  /// Allibera una referència a un mapa
  /// Si no hi ha més referències, elimina el mapa
  void releaseMap(String mapId) {
    if (!_maps.containsKey(mapId)) {
      Debug.warn("MapManager: Intent d'alliberar un mapa inexistent: $mapId");
      return;
    }
    
    // Decrementar el comptador de referències
    _refCounts[mapId] = (_refCounts[mapId] ?? 1) - 1;
    
    // Si no hi ha més referències, eliminar el mapa
    if (_refCounts[mapId]! <= 0) {
      _maps.remove(mapId);
      _refCounts.remove(mapId);
      _mapTypes.remove(mapId);
      Debug.info("MapManager: Mapa eliminat (ID: $mapId)");
    } else {
      Debug.info("MapManager: Mapa alliberat (ID: $mapId, Refs restants: ${_refCounts[mapId]})");
    }
  }
  
  // Funcionalitat interna ------------
  /// Comprova si dos mapes són iguals (recursivament)
  bool _areMapEqual(Map<String, dynamic> pMap1, Map<String, dynamic> pMap2) {
    if (pMap1.length != pMap2.length) return false;
    
    for (final key in pMap1.keys) {
      if (!pMap2.containsKey(key)) return false;
      
      final value1 = pMap1[key];
      final value2 = pMap2[key];
      
      // Ignorar callbacks (no es poden comparar)
      if (value1 is Function && value2 is Function) {
        continue;
      }
      
      if (value1 is Map && value2 is Map) {
        if (!_areMapEqual(value1 as Map<String, dynamic>, value2 as Map<String, dynamic>)) {
          return false;
        }
      } else if (value1 is List && value2 is List) {
        if (!_areListEqual(value1, value2)) {
          return false;
        }
      } else if (value1 != value2) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Comprova si dues llistes són iguals (recursivament)
  bool _areListEqual(List pList1, List pList2) {
    if (pList1.length != pList2.length) return false;
    
    for (int i = 0; i < pList1.length; i++) {
      final value1 = pList1[i];
      final value2 = pList2[i];
      
      if (value1 is Map && value2 is Map) {
        if (!_areMapEqual(value1 as Map<String, dynamic>, value2 as Map<String, dynamic>)) {
          return false;
        }
      } else if (value1 is List && value2 is List) {
        if (!_areListEqual(value1, value2)) {
          return false;
        }
      } else if (value1 != value2) {
        return false;
      }
    }
    
    return true;
  }

  // Altra funcionalitat --------------
  /// Obté estadístiques sobre l'ús de mapes
  LdMap<dynamic> getStats() {
    final stats = <String, dynamic>{
      'totalMaps': _maps.length,
      'totalReferences': _refCounts.values.fold<int>(0, (sum, count) => sum + count),
      'mapsByType': <String, int>{},
    };
    
    // Comptar mapes per tipus
    for (var mapId in _maps.keys) {
      final type = _mapTypes[mapId] ?? "unknown";
      stats['mapsByType'][type] = (stats['mapsByType'][type] ?? 0) + 1;
    }
    
    return stats;
  }
  
  /// Neteja mapes que ja no tenen referències
  int cleanup() {
    final keysToRemove = <String>[];
    
    // Trobar claus per eliminar
    for (var entry in _refCounts.entries) {
      if (entry.value <= 0) {
        keysToRemove.add(entry.key);
      }
    }
    
    // Eliminar els mapes
    for (var key in keysToRemove) {
      _maps.remove(key);
      _refCounts.remove(key);
      _mapTypes.remove(key);
    }
    
    Debug.info("MapManager: Neteja completada. ${keysToRemove.length} mapes eliminats.");
    return keysToRemove.length;
  }
  
  /// Crea una còpia d'un mapa existent
  String duplicateMap(String pMapId, {String? pNewIdent}) {
    assert(_maps.containsKey(pMapId), "Mapa no trobat: $pMapId");
    
    final originalMap = _maps[pMapId]!;
    final type = _mapTypes[pMapId] ?? "generic";
    
    // Registrar una còpia del mapa
    return registerMap(
      Map<String, dynamic>.from(originalMap),
      pType: type,
      pIdent: pNewIdent,
    );
  }
  
  /// Modifica un mapa existent
  /// Retorna el nou ID si es crea un nou mapa (perquè hi ha més referències)
  String updateMap(String pMapId, LdMap<dynamic> pUpdates) {
    assert(_maps.containsKey(pMapId), "Mapa no trobat: $pMapId");
    
    // Si hi ha més d'una referència, hem de crear un nou mapa
    if (_refCounts[pMapId]! > 1) {
      // Reduir la referència al mapa original
      _refCounts[pMapId] = _refCounts[pMapId]! - 1;
      
      // Crear una còpia i aplicar les actualitzacions
      final originalMap = Map<String, dynamic>.from(_maps[pMapId]!);
      final type = _mapTypes[pMapId] ?? "generic";
      
      // Aplicar les actualitzacions
      originalMap.addAll(pUpdates);
      
      // Registrar el nou mapa
      return registerMap(
        originalMap,
        pType: type,
      );
    } else {
      // Si només hi ha una referència, podem modificar el mapa directament
      _maps[pMapId]!.addAll(pUpdates);
      return pMapId;
    }
  }
}