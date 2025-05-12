// lib/core/services/maps_service.dart
// Servei centralitzat d'instàncies de models de dades.
// Created: 2025/05/09 dv. CLA[JIQ]
// Updated: 2025/05/11 ds. CLA - Canvi de nom de ModelService a MapsService

import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Enum per als tipus de mapes amb valors de constant
enum MapType {
  widget(kMapTypeWidget),
  entity(kMapTypeEntity),
  config(kMapTypeConfig);
  
  final String value;
  const MapType(this.value);
}

class MapsService {
  // Variables estàtiques 
  static final Map<String, Map<String, dynamic>> _maps = {};
  static final Map<String, int> _referenceCounts = {};
  static final Map<String, String> _mapTypes = {};

  // Singleton
  static final MapsService s = MapsService._internal();
  factory MapsService() => s;
  MapsService._internal();

  /// Registra un mapa amb un tag i tipus específics
  /// Retorna el tag del mapa registrat
  String registerMap(String tag, Map<String, dynamic> map, String type) {
    _maps[tag] = Map<String, dynamic>.from(map);
    _referenceCounts[tag] = (_referenceCounts[tag] ?? 0) + 1;
    _mapTypes[tag] = type;
    
    // Processar segons el tipus
    if (type == kMapTypeWidget) {
      _processWidgetMap(tag, map);
    } else if (type == kMapTypeEntity) {
      _processEntityMap(tag, map);
    } else if (type == kMapTypeConfig) {
      _processConfigMap(tag, map);
    }
    
    return tag;
  }

  /// Registra un mapa de widget
  String registerWidgetMap(String tag, Map<String, dynamic> map) {
    return registerMap(tag, map, kMapTypeWidget);
  }
  
  /// Registra un mapa d'entitat
  String registerEntityMap(String tag, Map<String, dynamic> map) {
    return registerMap(tag, map, kMapTypeEntity);
  }
  
  /// Registra un mapa de configuració
  String registerConfigMap(String tag, Map<String, dynamic> map) {
    return registerMap(tag, map, kMapTypeConfig);
  }

  /// Obté un mapa per tag
  static Map<String, dynamic> getMap(String tag) {
    return _maps[tag] ?? {};
  }

  /// Obté un model d'un tipus específic
  static T getModel<T>(String type, String tag) {
    final mapType = _mapTypes[tag];
    if (mapType != type) {
      throw Exception('Type mismatch: expected $type but found $mapType for tag $tag');
    }
    
    final model = _maps[tag]?['model'];
    if (model == null) {
      throw Exception('Model not found for tag: $tag');
    }
    
    if (model is! T) {
      throw Exception('Type mismatch: expected $T but found ${model.runtimeType} for tag $tag');
    }
    
    return model;
  }

  /// Obté un model de widget
  static T getWidgetModel<T>(String tag) {
    return getModel<T>(kMapTypeWidget, tag);
  }
  
  /// Obté un model d'entitat
  static T getEntityModel<T>(String tag) {
    return getModel<T>(kMapTypeEntity, tag);
  }
  
  /// Obté un model de configuració
  static T getConfigModel<T>(String tag) {
    return getModel<T>(kMapTypeConfig, tag);
  }

  /// Actualitza un mapa existent
  void updateMap(String tag, Map<String, dynamic> updates) {
    if (!_maps.containsKey(tag)) {
      throw Exception('Map not found: $tag');
    }
    
    _maps[tag]!.addAll(updates);
  }

  /// Allibera un mapa
  void releaseMap(String tag) {
    if (!_maps.containsKey(tag)) return;
    
    final count = _referenceCounts[tag]! - 1;
    if (count <= 0) {
      _maps.remove(tag);
      _referenceCounts.remove(tag);
      _mapTypes.remove(tag);
    } else {
      _referenceCounts[tag] = count;
    }
  }

  /// Processa un mapa de widget
  void _processWidgetMap(String tag, Map<String, dynamic> map) {
    // Lògica específica per widgets
    if (tag.startsWith('$kMapTypeWidget.')) {
      // Auto-expiration per widgets temporals
      // TODO: implementar si cal
    }
  }

  /// Processa un mapa d'entitat
  void _processEntityMap(String tag, Map<String, dynamic> map) {
    // Lògica específica per entitats
    // Pot incloure validació, normalització, etc.
  }

  /// Processa un mapa de configuració
  void _processConfigMap(String tag, Map<String, dynamic> map) {
    // Lògica específica per configuració
    // Pot incloure persistència, observers, etc.
  }

  /// Neteja tots els mapes
  void clear() {
    _maps.clear();
    _referenceCounts.clear();
    _mapTypes.clear();
  }

  /// Debug: mostra l'estat actual dels mapes
  void debug() {
    Debug.info('=== MapsService Debug ===');
    Debug.info('Total maps: ${_maps.length}');
    for (var tag in _maps.keys) {
      Debug.info('Tag: $tag, Type: ${_mapTypes[tag]}, Refs: ${_referenceCounts[tag]}');
    }
  }
}