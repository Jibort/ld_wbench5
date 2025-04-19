// ld_tag_builder_mixin.dart
// Responsable de formar tags únics correctes per a les instàncies de les classes.
// que fan mix amb 'LdTagMixin'.
// CreatedAt: 2025/04/13 dl. JIQ

import '../10_tools/ld_map.dart';

/// Responsable de formar tags únic correctes per a les instàncies de les classes.
class LdTagBuilder {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdTagBuilder";

  static final LdMap<int> _cnts  = LdMap<int>();
  static const String cntViews   = "cntViews";
  static const String cntWidgets = "cntWidgets";
  static const String cntModels  = "cntModels";
  static const String cntCtrls   = "cntCtrls";
  static const String cntServs   = "cntServs";

  // 📐 FUNCIONALITAT ESTÀTICA ---------
  /// Retorna el següent identificador únic per a vistes.
  static int get _newViewId => _newId(cntViews);
  /// Retorna el següent tag únic per a vistes.
  static String newViewTag(String pTag) => "${pTag}_$_newViewId";

  /// Retorna el següent identificador únic per a widgets.
  static int get _newWidgetId => _newId(cntWidgets);
  /// Retorna el següent tag únic per a widgets.
  static String newWidgetTag(String pTag) => "${pTag}_$_newWidgetId";

  /// Retorna el següent identificador únic per a models.
  static int get _newModelId => _newId(cntModels);
  /// Retorna el següent tag únic per a models.
  static String newModelTag(String pTag) => "${pTag}_$_newModelId";

  /// Retorna el següent identificador únic per a controladors.
  static int get _newCtrlId => _newId(cntCtrls);

  /// Retorna el següent tag únic per a models.
  static String newCtrlTag(String pTag) => "${pTag}_$_newCtrlId";

  /// Retorna el següent tag únic per a una categoria ad-hoc.
  static String newTag(String pCategory, String pTag) => "${pTag}_${_newId(pCategory)}"; 

  /// Retorna el següent identificador únic per a serveis.
  static int get _newServiceId => _newId(cntServs);
  /// Retorna el següent tag únic per a serveis.
  static String newServiceTag(String pTag) => "${pTag}_$_newServiceId";

  /// Retorna el següent identificador únic per a una categoria customitzada.
  static int _newId(String pCategory) {
    int cnt = _cnts[pCategory]?? 0;
    _cnts[pCategory] = ++cnt;
    return cnt;
  }
}
