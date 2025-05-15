// lib/ui/widgets/ld_scaffold/ld_scaffold_model.dart
// Model pel widget LdScaffold.
// Created: 2025/05/03 ds. CLA

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Model pel widget LdScaffold.
/// Aquest model és bàsicament buit, però existeix per complir amb l'arquitectura.
class LdScaffoldModel extends LdWidgetModelAbs<LdScaffold> {
  /// Constructor
  LdScaffoldModel(super.pWidget) {
    Debug.info("$tag: Model del Scaffold creat");
  }
  
  @override
  void fromMap(LdMap pMap) {
    super.fromMap(pMap);
    // No hi ha propietats específiques per carregar
  }
  
  @override
  MapDyns toMap() {
    final map = super.toMap();
    // No hi ha propietats específiques per afegir
    return map;
  }
}