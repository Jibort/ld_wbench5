// ld_tag_builder_mixin.dart
// Classe encarregada de formar tags únic correctes per a les instàncies de les classes
// que fan mix amb 'LdTagMixin'.
// CreatedAt: 2025/04/13 dl. JIQ

import 'package:ld_wbench5/10_tools/ld_map.dart';

/// Classe encarregada de formar tags únic correctes per a les instàncies de les classes
class LdTagBuilder {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdTagBuilder";
  static final LdMap<int> _cnts = LdMap<int>();
  static const String cntViews   = "cntViews";
  static const String cntWidgets = "cntWidgets";
  static const String cntModels  = "cntModels";
  static const String cntCtrls   = "cntCtrls";

  // 📐 FUNCIONALITAT ESTÀTICA ---------
  /// Retorna el següent identificador únic per a vistes.
  static int get newViewId => newId(cntViews);
  /// Retorna el següent tag únic per a vistes.
  static String newViewTag(String pTag) => "${pTag}_$newViewId";

  /// Retorna el següent identificador únic per a widgets.
  static int get newWidgetId => newId(cntWidgets);
  /// Retorna el següent tag únic per a widgets.
  static String newWidgetTag(String pTag) => "${pTag}_$newWidgetId";

  /// Retorna el següent identificador únic per a models.
  static int get newModelId => newId(cntModels);
  /// Retorna el següent tag únic per a models.
  static String newModelTag(String pTag) => "${pTag}_$newModelId";

  /// Retorna el següent identificador únic per a controladors.
  static int get newCtrlId => newId(cntCtrls);
  /// Retorna el següent tag únic per a models.
  static String newCtrlTag(String pTag) => "${pTag}_$newCtrlId";

  /// Retorna el següent identificador únic per a una categoria customitzada.
  static int newId(String pCategory) {
    int cnt = _cnts[pCategory]?? 0;
    _cnts[pCategory] = ++cnt;
    return cnt;
  }
}
