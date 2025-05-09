// ld_model_abs.dart
// Model base simplificat per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/widgets.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';

/// Interfície per a comunicar canvis en el model
abstract class LdModelObserverIntf {
  /// Notifica que el model ha canviat
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate);
}

/// Model base que proporciona funcionalitat de notificació de canvis
abstract class LdModelAbs 
with     LdTaggableMixin {
  /// Conjunt d'observadors interessats en canvis del model
  final Set<LdModelObserverIntf> _observers = {};
  
  /// Retorna el nombre d'observadors actuals
  int get observerCount => _observers.length;

  /// Indica si el model té algun observador
  bool get hasObservers => _observers.isNotEmpty;

  /// Vincula un observador a aquest model per a les actualitzacions d'UI
  void attachObserver(LdModelObserverIntf pObs) {
    _observers.add(pObs);
    Debug.info("$tag: Observador assignat. Total: ${_observers.length}");
  }
  
  /// Desvincula un observador específic
  void detachObserver([LdModelObserverIntf? pObs]) {
    if (pObs != null) {
      _observers.remove(pObs);
      Debug.info("$tag: Observador específic desvinculat. Restants: ${_observers.length}");
    } else {
      _observers.clear();
      Debug.info("$tag: Tots els observadors desvinculats");
    }
  }
  
  /// Notifica als observadors que el model ha canviat
  void notifyListeners(void Function() action, [bool pOnlyWithObs = false]) {
    if (_observers.isNotEmpty || !pOnlyWithObs) {
      action();
     }
    
    // Si hi ha observadors, notificar-los del canvi
    if (_observers.isNotEmpty) {
      Debug.info("$tag: Notificant ${_observers.length} observador(s) del canvi");
      for (final observer in _observers) {
        observer.onModelChanged(this, action);
      }
    } else {
      Debug.warn("$tag: Model canviat sense observadors");
    }
  }
  
  /// Allibera els recursos del model
  @mustCallSuper
  void dispose() {
    detachObserver(); // Ara desvincula tots els observadors
    Debug.info("$tag: Model alliberat");
  }

  @override String toString() => 'LdModel(tag: $tag)';

  // DECLARACIONS ABSTRACTES ==================================================
  /// Retorna un mapa amb els membres del model.
  @mustCallSuper
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = LdMap();
    map[mfTag] = tag;
    return map;
  }
  /// Estableix els valor del model a partir del contingut del mapa.
  @mustCallSuper
  void fromMap(LdMap<dynamic> pMap) {
    tag = pMap[mfTag];
  }

  /// Retorna el valor associat amb un membre del model.
  @mustCallSuper
  dynamic getField({ required String pKey, bool pCouldBeNull = true, String? pErrorMsg })
  => (pKey == mfTag)
    ? tag
    : Debug.fatal("$tag.getField('$pKey'): cap camp té la clau '$pKey'!");

  /// Estableix el valor associat amb un membre del model.
  @mustCallSuper
  void setField({ required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg })
  => (pKey == mfTag && pValue is String)
    ? tag = pValue
    : Debug.fatal("$tag.setField('$pKey', '$pValue'): cap camp té la clau '$pKey' o el tipus és incorrecte!");
}