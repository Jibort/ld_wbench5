// lib/ui/widgets/ld_foldable_container/ld_foldable_container_model.dart
// Model de dades per al widget LdFoldableContainer
// Created: 2025/05/17 ds. CLA

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';

/// Model de dades per al widget LdFoldableContainer
class LdFoldableContainerModel extends LdWidgetModelAbs {
  // MEMBRES ==============================================
  /// Indica si el contingut està expandit
  bool _isExpanded = true;
  bool get isExpanded => _isExpanded;
  set isExpanded(bool value) {
    if (_isExpanded != value) {
      notifyListeners(() {
        _isExpanded = value;
        //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Estat d'expansió canviat a $value");
      });
    }
  }
  
  /// Clau de traducció o text per al títol
  String? _titleKey;
  String? get titleKey => _titleKey;
  set titleKey(String? value) {
    if (_titleKey != value) {
      notifyListeners(() {
        _titleKey = value;
        //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Clau de títol canviada a '$value'");
      });
    }
  }
  
  /// Clau de traducció o text per al subtítol
  String? _subtitleKey;
  String? get subtitleKey => _subtitleKey;
  set subtitleKey(String? value) {
    if (_subtitleKey != value) {
      notifyListeners(() {
        _subtitleKey = value;
        //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Clau de subtítol canviada a '$value'");
      });
    }
  }
  
  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Constructor des de mapa
  LdFoldableContainerModel.fromMap(MapDyns pMap) : super.fromMap(pMap) {
    fromMap(pMap);
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Model creat des de mapa");
  }
  
  // MAPEJAT ==============================================
  @override
  void fromMap(MapDyns pMap) {
    super.fromMap(pMap);
    
    // Carregar dades del model
    _isExpanded = pMap[mfIsExpanded] as bool? ?? true;
    _titleKey = pMap[mfTitleKey] as String?;
    _subtitleKey = pMap[mfSubtitleKey] as String?;
    
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Model carregat des de mapa amb isExpanded=$_isExpanded, titleKey='$_titleKey', subtitleKey='$_subtitleKey'");
  }
  
  @override
  MapDyns toMap() {
    final map = super.toMap();
    map.addAll({
      mfIsExpanded: _isExpanded,
      mfTitleKey: _titleKey,
      mfSubtitleKey: _subtitleKey,
    });
    return map;
  }
  
  @override
  dynamic getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case mfIsExpanded: return isExpanded;
      case mfTitleKey: return titleKey;
      case mfSubtitleKey: return subtitleKey;
      default: return super.getField(
        pKey: pKey,
        pCouldBeNull: pCouldBeNull,
        pErrorMsg: pErrorMsg
      );
    }
  }
  
  @override
  bool setField({required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case mfIsExpanded:
        if (pValue is bool) {
          isExpanded = pValue;
          return true;
        }
        break;
      case mfTitleKey:
        if (pValue is String? || (pValue == null && pCouldBeNull)) {
          titleKey = pValue as String?;
          return true;
        }
        break;
      case mfSubtitleKey:
        if (pValue is String? || (pValue == null && pCouldBeNull)) {
          subtitleKey = pValue as String?;
          return true;
        }
        break;
      default:
        return super.setField(
          pKey: pKey,
          pValue: pValue,
          pCouldBeNull: pCouldBeNull,
          pErrorMsg: pErrorMsg
        );
    }
    return false;
  }
}