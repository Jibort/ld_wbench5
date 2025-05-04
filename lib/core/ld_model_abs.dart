// ld_model_abs.dart
// Model base simplificat per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/widgets.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/map_extensions.dart';

/// Interfície per a comunicar canvis en el model
abstract class LdModelObserverIntf {
  /// Notifica que el model ha canviat
  void onModelChanged(void Function() pfUpdate);
}

/// Model base que proporciona funcionalitat de notificació de canvis
abstract class LdModelAbs 
with     LdTaggableMixin {
  /// Observador opcional associat per actualitzar la UI
  LdModelObserverIntf? _obs;
  
  /// Vincula un observador a aquest model per a les actualitzacions d'UI
  void attachObserver(LdModelObserverIntf pObs) {
    _obs = pObs;
    Debug.info("$tag: Observador assignat");
  }
  
  /// Desvincula l'observador
  void detachObserver() {
    _obs = null;
    Debug.info("$tag: Observador desvinculat");
  }
  
  /// Notifica als observadors que el model ha canviat
  void notifyListeners(void Function() action) {
    // Executa l'acció sempre, independentment de l'observador
    action();
    
    // Si hi ha un observador, notifica-li del canvi
    if (_obs != null) {
      _obs!.onModelChanged(action);
      Debug.info("$tag: Canvi notificat a l'observador");
    } else {
      Debug.info("$tag: Canvi en el model sense observador");
    }
  }
  
  /// Allibera els recursos del model
  void dispose() {
    _obs = null;
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