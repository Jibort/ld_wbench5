// ld_page.dart
// Pàgina base simplificada per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/11 ds. CLA - Optimització amb GlobalKey transparent

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_ctrl_abs.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_model_abs.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/maps_service.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'ld_page_ctrl_abs.dart';
export 'ld_page_model_abs.dart';

/// Pàgina base que proporciona funcionalitats comunes
abstract   class LdPageAbs 
extends    StatefulWidget 
with       LdTaggableMixin
implements LdModelObserverIntf {
  // MEMBRES ==============================================
  /// ID del mapa de configuració
  late final String _mapId;
  
  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Constructor principal amb mapa de configuració
  LdPageAbs({
    String? pTag,
    LdMap<dynamic>? pConfig,
    Key? pKey }) 
  : super(key: pKey) {
    tag = pTag ?? generateTag(); // JAB_6: "LdPage_${DateTime.now().millisecondsSinceEpoch}";
    final fullConfig = _buildFullConfig(tag, pConfig ?? LdMap<dynamic>());
    _mapId = MapsService.s.registerMap(tag, fullConfig, kMapTypeWidget);
    
    Debug.info("$tag: Creant pàgina amb mapa (ID: $_mapId)");
  }

  static LdMap<dynamic> _buildFullConfig(String tag, LdMap<dynamic> config) {
    final map = LdMap<dynamic>.from(config);
    // Assegurar que el tag està al mapa
    map[cfTag] = tag;
    return map;
  }

  /// Allibera recursos quan la pàgina és eliminada
  void cleanup() {
    MapsService.s.releaseMap(_mapId);
    Debug.info("$tag: Recursos de la pàgina alliberats");
  }

  /// Obté el mapa de configuració
  LdMap<dynamic> get config => MapsService.getMap(_mapId);
  
  // JAB_6: /// Constructor
  // LdPageAbs({
  //   String? pTag,
  // }) : super(key: null) {
  //   tag = pTag ?? className;
  //   Debug.info("$tag: Creant pàgina");
  // }
  
  // ACCÉS AL CONTROLADOR ===================================================
  /// Retorna el controlador de la pàgina utilitzant la GlobalKey
  LdPageCtrlAbs? get vCtrl {
    if (globalKey == null) {
      // Forçar la creació de la GlobalKey
      forceGlobalKey<LdPageCtrlAbs>();
    }
    return getState<LdPageCtrlAbs>();
  }
  
  /// Retorna el controlador de la pàgina (versió que garanteix non-null)
  LdPageCtrlAbs get vCtrlRequired {
    final ctrl = vCtrl;
    assert(ctrl != null, "$tag: Controlador de pàgina no disponible encara");
    return ctrl!;
  }
  
  /// Sobreescrivim key per retornar la GlobalKey sota demanda
  @override
  Key? get key {
    if (globalKey == null) {
      // Crear la GlobalKey amb el tipus genèric adequat
      forceGlobalKey<LdPageCtrlAbs>();
    }
    return globalKey;
  }
  
  // ACCÉS AL MODEL (delegat al controlador) ================================
  /// Retorna el model de la pàgina (accés a través del controlador)
  LdPageModelAbs? get vModel => vCtrl?.model;
  
  /// Retorna el model de la pàgina (versió que garanteix non-null)
  LdPageModelAbs get vModelRequired {
    final model = vModel;
    assert(model != null, "$tag: Model de pàgina no disponible encara");
    return model!;
  }
  
  /// Indica si la pàgina té un model assignat
  bool get hasModel => vModel != null;

  // OBSERVADOR DEL MODEL ===================================================
  /// Implementació del LdModelObserverIntf
  @override
  void onModelChanged(LdModelAbs model, void Function() pfUpdate) {
    // Delegar al controlador quan estigui disponible
    final ctrl = vCtrl;
    if (ctrl != null) {
      ctrl.onModelChanged(model, pfUpdate);
    } else {
      // Si el controlador no està disponible encara, 
      // només executar la funció d'actualització
      pfUpdate();
    }
  }
  
  /// CREACIÓ DE CONTROLADOR ================================================
  /// Mètode que cada pàgina ha d'implementar per crear el seu controlador
  @protected
  LdPageCtrlAbs createCtrl();
  
  /// Retorna el controlador de la pàgina
  @override
  State<LdPageAbs> createState() => createCtrl();
}