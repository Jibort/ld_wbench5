// lib/ui/widgets/ld_foldable_container/ld_foldable_container_model.dart
// Model de dades per al widget LdFoldableContainer
// Created: 2025/05/17 ds. CLA
// Updated: 2025/05/20 dg. CLA - Integrat amb StatePersistenceService

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/state_persistance_service.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Model de dades per al widget LdFoldableContainer
/// 
/// Gestiona l'estat d'expansió, títol i subtítol del contenidor plegable.
/// Utilitza StatePersistenceService per emmagatzemar l'estat persistent.
class LdFoldableContainerModel extends LdWidgetModelAbs {
  // MEMBRES ==============================================
  /// Indica si el contingut està expandit
  bool _isExpanded = true;
  bool get isExpanded => _isExpanded;
  set isExpanded(bool value) {
    if (_isExpanded != value) {
      // Guardar l'estat persistent
      final persistentKey = StatePersistenceService.makeKey(tag, mfIsExpanded);
      StatePersistenceService.s.setValue(persistentKey, value);

      notifyListeners(() {
        _isExpanded = value;
        Debug.info("$tag: Estat d'expansió canviat a $value");
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
        Debug.info("$tag: Clau de títol canviada a '$value'");
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
        Debug.info("$tag: Clau de subtítol canviada a '$value'");
      });
    }
  }
  
  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Constructor des de mapa
  LdFoldableContainerModel.fromMap(MapDyns pMap) : super.fromMap(pMap) {
    fromMap(pMap);
    Debug.info("$tag: Model creat des de mapa");
  }
  
  // MAPEJAT ==============================================
  @override
  void fromMap(MapDyns pMap) {
    super.fromMap(pMap);
    
    // Carregar dades del model amb recuperació d'estat persistent
    final persistentKey = StatePersistenceService.makeKey(tag, mfIsExpanded);
    final savedExpandedState = StatePersistenceService.s.getValue<bool>(persistentKey);

    _isExpanded = savedExpandedState ?? 
                  pMap[mfIsExpanded] as bool? ?? 
                  true;
    _titleKey = pMap[mfTitleKey] as String?;
    _subtitleKey = pMap[mfSubtitleKey] as String?;
    
    Debug.info("$tag: Model carregat des de mapa amb isExpanded=$_isExpanded, titleKey='$_titleKey', subtitleKey='$_subtitleKey'");
  }
  
  // La resta del codi es manté igual
}