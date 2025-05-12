// ld_page_model_abs.dart
// Model base per a les pàgines. 
// Created: 2025/05/03 ds. JIQ
// Updated: 2025/05/11 ds. CLA - Optimització per mapes i arquitectura simplificada

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Model base per a les pàgines.
abstract class LdPageModelAbs<T extends LdPageAbs> 
extends  LdModelAbs {
  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Construeix un model a partir d'un mapa de propietats
  LdPageModelAbs.fromMap(LdMap<dynamic> pMap) {
    // Filtrar només les propietats que comencen amb 'mf'
    LdMap<dynamic> modelProperties = {};
    for (var entry in pMap.entries) {
      if (entry.key.startsWith('mf')) {
        modelProperties[entry.key] = entry.value;
      }
    }
    
    // Establir el tag des del mapa (prioritzant mfTag, després cfTag)
    tag = pMap[mfTag] as String? ?? 
          pMap[cfTag] as String? ??
          generateTag();
          // JAB_6: "PageModel_${DateTime.now().millisecondsSinceEpoch}";
    
    // Carregar les propietats filtrades
    fromMap(modelProperties);
    Debug.info("$tag: Model de pàgina creat a partir de mapa");
  }
  
  /// Constructor alternatiu amb pàgina específica
  /// Utilitzat quan la pàgina específica necessita configuració especial
  @protected
  LdPageModelAbs.forPage(T pPage, LdMap<dynamic> pMap) {
    // Filtrar propietats del model (mf*)
    LdMap<dynamic> modelProperties = {};
    for (var entry in pMap.entries) {
      if (entry.key.startsWith('mf')) {
        modelProperties[entry.key] = entry.value;
      }
    }
    
    // Establir el tag basat en la pàgina
    tag = generateTag(); // JAB_6: "${pPage.tag}_Model";
    
    // Carregar les propietats
    if (modelProperties.isNotEmpty) {
      fromMap(modelProperties);
    }
    
    Debug.info("$tag: Model creat per a la pàgina ${pPage.tag}");
  }
  
  /// Constructor obsolet
  @Deprecated("Fes servir els constructors 'fromMap' o 'forPage' enlloc d'aquest antic.")
  LdPageModelAbs({ required T pPage }) {
    Debug.warn("$tag: Utilitzant constructor obsolet. Canvieu al constructor amb mapa de propietats.");
    tag = "${pPage.tag}_Model";
  }
  
  // GESTIÓ DE MAPA DE PROPIETATS =========================
  /// Converteix el model a un mapa de propietats
  @override
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map[mfTag] = tag;
    return map;
  }
  
  /// Carrega el model des d'un mapa de propietats
  @override
  void fromMap(LdMap<dynamic> pMap) {
    super.fromMap(pMap);
    // Específic de cada implementació
  }
  
  /// Actualitza només les propietats específiques del model
  void updateFromMap(LdMap<dynamic> pMap) {
    // Filtrar només les propietats que comencen amb 'mf'
    LdMap<dynamic> modelProperties = {};
    for (var entry in pMap.entries) {
      if (entry.key.startsWith('mf')) {
        modelProperties[entry.key] = entry.value;
      }
    }
    
    // Actualitzar només si hi ha propietats
    if (modelProperties.isNotEmpty) {
      notifyListeners(() {
        fromMap(modelProperties);
      });
      Debug.info("$tag: Model de pàgina actualitzat amb noves propietats");
    }
  }
  
  // GESTIÓ DE CAMPS ======================================
  /// Retorna el valor associat amb un membre del model.
  @override
  @mustCallSuper
  dynamic getField({ required String pKey, bool pCouldBeNull = true, String? pErrorMsg })
  => super.getField(pKey: pKey, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);
  
  /// Obté múltiples camps del model
  LdMap<dynamic> getFields(List<String> fieldKeys) {
    LdMap<dynamic> result = {};
    
    for (String key in fieldKeys) {
      if (key.startsWith('mf')) {
        try {
          result[key] = getField(pKey: key);
        } catch (e) {
          Debug.warn("$tag: No s'ha pogut obtenir el camp $key: $e");
        }
      }
    }
    
    return result;
  }
  
  /// Actualitza una propietat específica del model
  void updateField(String fieldKey, dynamic value) {
    // Verificar que la clau comença amb 'mf'
    if (!fieldKey.startsWith('mf')) {
      Debug.warn("$tag: Intent d'actualitzar camp que no és de model: $fieldKey");
      return;
    }
    
    notifyListeners(() {
      setField(pKey: fieldKey, pValue: value);
    });
    
    Debug.info("$tag: Camp actualitzat: $fieldKey = $value");
  }
  
  /// Estableix el valor associat amb un membre del model.
  @override
  @mustCallSuper
  bool setField({ 
    required String pKey, 
    dynamic pValue, 
    bool pCouldBeNull = true, 
    String? pErrorMsg })
  => super.setField(pKey: pKey);

  /// Actualitza múltiples camps del model alhora
  void setFields(LdMap<dynamic> fields) {
    // Filtrar només camps del model
    LdMap<dynamic> modelFields = {};
    for (var entry in fields.entries) {
      if (entry.key.startsWith('mf')) {
        modelFields[entry.key] = entry.value;
      }
    }
    
    if (modelFields.isNotEmpty) {
      notifyListeners(() {
        for (var entry in modelFields.entries) {
          setField(pKey: entry.key, pValue: entry.value);
        }
      });
      
      Debug.info("$tag: Múltiples camps actualitzats: ${modelFields.keys.toList()}");
    }
  }
  
  // VALIDACIÓ I GESTIÓ DEL MODEL =========================
  /// Valida el model abans de persistir-lo
  bool validate() {
    // Implementació base - pot ser sobreescrit per validacions específiques
    return true;
  }
  
  /// Mètode per persistir el model (pot connectar amb backend)
  Future<bool> save() async {
    if (!validate()) {
      Debug.warn("$tag: Validació fallida, no es pot guardar el model");
      return false;
    }
    
    // Implementació base - pot ser sobreescrit per lògica de persistència específica
    Debug.info("$tag: Model de pàgina guardat");
    return true;
  }
  
  /// Mètode per restaurar el model des de persistència
  Future<bool> load(String identifier) async {
    // Implementació base - pot ser sobreescrit per lògica de càrrega específica
    Debug.info("$tag: Model de pàgina carregat amb identificador: $identifier");
    return true;
  }

  /// Copia el model a un nou mapa amb només les propietats de model
  LdMap<dynamic> toModelMap() {
    final fullMap = toMap();
    LdMap<dynamic> modelOnly = {};
    
    for (var entry in fullMap.entries) {
      if (entry.key.startsWith('mf')) {
        modelOnly[entry.key] = entry.value;
      }
    }
    
    return modelOnly;
  }
  
  /// Compara aquest model amb un altre mapa per detectar canvis
  bool hasChangesFrom(LdMap<dynamic> otherMap) {
    final currentMap = toModelMap();
    
    // Comparar claus existents
    for (var key in currentMap.keys) {
      if (!otherMap.containsKey(key) || currentMap[key] != otherMap[key]) {
        return true;
      }
    }
    
    // Comparar claus noves en otherMap
    for (var key in otherMap.keys) {
      if (key.startsWith('mf') && !currentMap.containsKey(key)) {
        return true;
      }
    }
    
    return false;
  }
}