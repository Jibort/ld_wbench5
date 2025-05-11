// ld_widget_abs.dart
// Widget base totalment simplificat
// Updated: 2025/05/11 ds. CLA - Eliminació de tots els camps redundants

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/maps_service.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'ld_widget_ctrl_abs.dart';
export 'ld_widget_model_abs.dart';

/// Widget base que proporciona funcionalitats comunes
abstract class LdWidgetAbs extends StatefulWidget 
    with LdTaggableMixin 
    implements LdModelObserverIntf {
  
  /// ID del mapa de configuració
  final String _mapId;
  
  /// Constructor principal amb mapa de configuració
  LdWidgetAbs({
    required LdMap<dynamic> config,
  }) : _mapId = MapsService.s.registerMap(
         config, 
         pType: "widget",
         pIdent: config[cfTag] as String?,
       ),
       super(key: null) {
    
    // Assignar el tag des del mapa de configuració
    tag = config[cfTag] as String? ?? 
          "LdWidget_${DateTime.now().millisecondsSinceEpoch}";
    
    Debug.info("$tag: Creant widget amb mapa (ID: $_mapId)");
  }
  
  /// Sobreescrivim key per retornar la GlobalKey sota demanda
  @override
  Key? get key {
    if (globalKey == null) {
      // Crear la GlobalKey amb el tipus genèric adequat
      forceGlobalKey<LdWidgetCtrlAbs>();
    }
    return globalKey;
  }
  
  /// Allibera recursos quan el widget és eliminat
  void cleanup() {
    MapsService.s.releaseMap(_mapId);
    Debug.info("$tag: Recursos del widget alliberats");
  }
  
  /// Obté el mapa de configuració
  LdMap<dynamic> get config => MapsService.s.getMap(_mapId);
  
  // ACCÉS AL CONTROLADOR ===================================================
  /// Retorna el controlador del widget utilitzant la GlobalKey
  LdWidgetCtrlAbs? get wCtrl {
    if (globalKey == null) {
      // Forçar la creació de la GlobalKey
      forceGlobalKey<LdWidgetCtrlAbs>();
    }
    return getState<LdWidgetCtrlAbs>();
  }
  
  /// Retorna el controlador del widget (versió que garanteix non-null)
  LdWidgetCtrlAbs get wCtrlRequired {
    final ctrl = wCtrl;
    assert(ctrl != null, "$tag: Controlador no disponible encara");
    return ctrl!;
  }
  
  // ACCÉS AL MODEL (delegat al controlador) ================================
  /// Retorna el model del widget (accés a través del controlador)
  LdWidgetModelAbs? get wModel => wCtrl?.model;
  
  /// Retorna el model del widget (versió que garanteix non-null)
  LdWidgetModelAbs get wModelRequired {
    final model = wModel;
    assert(model != null, "$tag: Model no disponible encara");
    return model!;
  }
  
  /// Indica si el widget té un model assignat
  bool get hasModel => wModel != null;

  // OBSERVADOR DEL MODEL ===================================================
  /// Implementació del LdModelObserverIntf
  @override
  void onModelChanged(LdModelAbs model, void Function() pfUpdate) {
    // Delegar al controlador quan estigui disponible
    final ctrl = wCtrl;
    if (ctrl != null) {
      ctrl.onModelChanged(model, pfUpdate);
    } else {
      // Si el controlador no està disponible ancora, 
      // només executar la funció d'actualització
      pfUpdate();
    }
  }
  
  /// CREACIÓ DE CONTROLADOR ================================================
  /// Mètode que cada widget ha d'implementar per crear el seu controlador
  @protected
  LdWidgetCtrlAbs createController();
  
  /// Retorna el controlador del widget
  @override
  State<LdWidgetAbs> createState() => createController();
}