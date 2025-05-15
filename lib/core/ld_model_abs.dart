// lib/core/ld_model_abs.dart
// Model base simplificat per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/widgets.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/utils/debug.dart';

// INTERFÍCIE D'OBSERVADORS ==============================
abstract class LdModelObserverIntf {
  /// Notifica que el model ha canviat
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate);
}

// MODEL BASE ============================================
abstract class LdModelAbs with LdTaggableMixin {
  // MEMBRES LOCALS =======================================
  final Set<LdModelObserverIntf> _observers = {};
  final MapDyns config;
  
  // GETTERS/SETTERS ======================================
  int get observerCount => _observers.length;
  bool get hasObservers => _observers.isNotEmpty;

  // FUNCIONALITAT OBSERVADORS ============================
  void attachObserver(LdModelObserverIntf pObs) {
    _observers.add(pObs);
    Debug.info("$tag: Observador assignat. Total: ${_observers.length}");
  }

  void detachObserver([LdModelObserverIntf? pObs]) {
    if (pObs != null) {
      _observers.remove(pObs);
      Debug.info("$tag: Observador específic desvinculat. Restants: ${_observers.length}");
    } else {
      _observers.clear();
      Debug.info("$tag: Tots els observadors desvinculats");
    }
  }

  void notifyListeners(void Function() action, [bool pOnlyWithObs = false]) {
    if (_observers.isNotEmpty || !pOnlyWithObs) {
      action();
    }
    if (_observers.isNotEmpty) {
      Debug.info("$tag: Notificant ${_observers.length} observador(s) del canvi");
      for (final observer in _observers) {
        observer.onModelChanged(this, action);
      }
    } else {
      Debug.warn("$tag: Model canviat sense observadors");
    }
  }

  // CONSTRUCTORS/DESTRUCTORS =============================
  LdModelAbs(this.config) {
    tag = config[cfTag] ?? generateTag();
  }

  @mustCallSuper
  void dispose() {
    detachObserver();
    Debug.info("$tag: Model alliberat");
  }

  @override
  String toString() => 'LdModel(tag: $tag)';

  // DECLARACIONS ABSTRACTES ==============================
  @mustCallSuper
  MapDyns toMap() {
    MapDyns map = LdMap();
    map[cfTag] = tag;
    return map;
  }

  @mustCallSuper
  void fromMap(MapDyns pMap) {
    tag = pMap[cfTag];
  }

  @mustCallSuper
  dynamic getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) =>
      (pKey == cfTag)
          ? tag
          : Debug.fatal("$tag.getField('$pKey'): cap camp té la clau '$pKey'!");

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