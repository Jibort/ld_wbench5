// lib/core/ld_model_abs.dart
// Model base simplificat per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/widgets.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/utils/debug.dart';


// WRAPPERS ===============================================
/// Wrapper intern per convertir funcions a interfície
class _FunctionObserverWrapper implements LdModelObserverIntf {
  final FnModelObs function;
  
  _FunctionObserverWrapper(this.function);
  
  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
    function(pModel, pfUpdate);
  }
}

// INTERFÍCIE D'OBSERVADORS ==============================
abstract class LdModelObserverIntf {
  /// Notifica que el model ha canviat
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate);
}

/// Model base simplificat per a l'aplicació
abstract class LdModelAbs 
with     LdTaggableMixin {
  // MEMBRES LOCALS =======================================
  final Set<LdModelObserverIntf> _observers = {};
  final MapDyns fields;

  // CONSTRUCTORS/DESTRUCTORS =============================
  LdModelAbs([ MapDyns? pFields ])
  : fields = pFields?? MapDyns() {
    tag = fields[cfTag] ?? generateTag();
  }

  @mustCallSuper
  void dispose() {
    detachObserver();
    Debug.info("$tag: Model alliberat");
  }

  // GETTERS/SETTERS ======================================
  int get observerCount => _observers.length;
  bool get hasObservers => _observers.isNotEmpty;

  // FUNCIONALITAT OBSERVADORS ============================
  void attachObserver(LdModelObserverIntf pObs) {
    _observers.add(pObs);
  }

  /// Mètode sobrecarregat per acceptar funcions directament
  void attachObserverFunction(FnModelObs pObserverFn) {
    final wrapper = _FunctionObserverWrapper(pObserverFn);
    _observers.add(wrapper);
  }

  void detachObserver([LdModelObserverIntf? pObs]) 
  => (pObs != null)
      ? _observers.remove(pObs)
      : _observers.clear();

  /// Mètode per desattach funcions observer
  void detachObserverFunction(FnModelObs pObserverFn) 
  => _observers.removeWhere((obs) => 
    obs is _FunctionObserverWrapper && 
    obs.function == pObserverFn
  );

  /// Informa als objectes que escolten canvis en el model sobre els canvis.
  void notifyListeners(void Function() action, [bool pOnlyWithObs = false]) {
    if (_observers.isNotEmpty || !pOnlyWithObs) {
      action();
    }
    if (_observers.isNotEmpty) {
      for (final observer in _observers) {
        observer.onModelChanged(this, action);
      }
    } else {
      Debug.warn("$tag: Model canviat sense observadors");
    }
  }

  /// Retorna la cadena indetificativa del model.
  @override
  String toString() => 'LdModel(tag: $tag)';

  // DECLARACIONS ABSTRACTES ==============================
  /// Retorna la versió del model en forma de mapa dinàmic.
  @mustCallSuper
  MapDyns toMap() {
    MapDyns map = LdMap();
    map[cfTag] = tag;
    return map;
  }

  /// Carrega els camps estructurals bàsics de tot model.
  @mustCallSuper
  MapDyns fromMap(MapDyns pMap) {
  // Verificar que pMap no sigui null
  if (pMap.isEmpty) return MapDyns();
  
  // Si cfTag existeix al mapa, actualitzem el tag
  // Si no, mantenim el tag existent o generem un nou
  String? tagFromMap = pMap[cfTag] as String?;
  tag = (tagFromMap != null)
    ? tagFromMap
    : (tag.isEmpty)
      ? generateTag()
      : tag;

  return pMap;
  }

  /// Retorna un camp del model base.
  @mustCallSuper
  dynamic getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) =>
    (fields.containsKey(pKey))
      ? fields[pKey]
       : (!pCouldBeNull)
         ? Debug.fatal("$tag.getField('$pKey'): cap camp té la clau '$pKey'!")
        : null;

  /// Estableix el valor d'un camp del model base.
  @mustCallSuper
  bool setField({required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg}) {
    if (pKey == cfTag && pValue is String) {
      tag = pValue;
      return true;
    }
    Debug.fatal("$tag.setField('$pKey', '$pValue'): cap camp té la clau '$pKey' o el tipus és incorrecte!");
    return false;
  }
}