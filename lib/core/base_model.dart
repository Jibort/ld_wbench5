// base_model.dart
// Model base simplificat per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:ld_wbench5/core/taggable_mixin.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Interfície per a comunicar canvis en el model
abstract class ModelObserver {
  /// Notifica que el model ha canviat
  void onModelChanged(void Function() updateFunction);
}

/// Model base que proporciona funcionalitat de notificació de canvis
class SabinaModel with LdTaggable {
  /// Observador opcional associat per actualitzar la UI
  ModelObserver? _observer;
  
  /// Vincula un observador a aquest model per a les actualitzacions d'UI
  void attachObserver(ModelObserver observer) {
    _observer = observer;
    Debug.info("$tag: Observador assignat");
  }
  
  /// Desvincula l'observador
  void detachObserver() {
    _observer = null;
    Debug.info("$tag: Observador desvinculat");
  }
  
  /// Notifica als observadors que el model ha canviat
  void notifyListeners(void Function() action) {
    // Executa l'acció sempre, independentment de l'observador
    action();
    
    // Si hi ha un observador, notifica-li del canvi
    if (_observer != null) {
      _observer!.onModelChanged(() {});
      Debug.info("$tag: Canvi notificat a l'observador");
    } else {
      Debug.info("$tag: Canvi en el model sense observador");
    }
  }
  
  /// Allibera els recursos del model
  void dispose() {
    _observer = null;
    Debug.info("$tag: Model alliberat");
  }
  
  @override
  String toString() => 'SabinaModel(tag: $tag)';
}