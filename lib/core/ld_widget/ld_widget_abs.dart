// lib/ui/widgets/ld_widget_abs.dart
// Widget base que proporciona funcionalitats comunes
// Created: 2025/05/13 dt. GPT[JIQ]
// Updated: 2025/05/14 dc. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';

import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/maps_service.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';

/// Classe base per a tots els widgets personalitzats del projecte
abstract   class LdWidgetAbs 
extends    StatefulWidget 
with       LdTaggableMixin 
implements LdModelObserverIntf {
  // MEMBRES ==============================================
  late final String _mapId;

  // CONSTRUCTORS/DESTRUCTORS =============================
  LdWidgetAbs({ Key? pKey, String? pTag, MapDyns? pConfig })
      : super(key: pKey) {
    tag = pTag ?? generateTag();
    final fullConfig = _buildFullConfig(tag, pConfig ?? MapDyns());
    _mapId = MapsService.s.registerMap(tag, fullConfig, kMapTypeWidget);
  }

  static MapDyns _buildFullConfig(String tag, MapDyns config) {
    final map = MapDyns.from(config);
    map[cfTag] = tag;
    return map;
  }

  void cleanup() => MapsService.s.releaseMap(_mapId);

  MapDyns get config => MapsService.getMap(_mapId);

  // ACCÉS AL CONTROLADOR =================================
  LdWidgetCtrlAbs? get ctrl {
    if (globalKey == null) forceGlobalKey<LdWidgetCtrlAbs>();
  
    var ctrl = getState<LdWidgetCtrlAbs>();
    assert(ctrl != null, "$tag: Controlador no disponible encara");
    return ctrl;
  }

  @override
  Key? get key {
    if (globalKey == null) {
      forceGlobalKey<LdWidgetCtrlAbs>();
    }
    return globalKey;
  }

  // ACCÉS AL MODEL (delegat al controlador) ==============
  LdWidgetModelAbs? get model => ctrl?.model;

  LdWidgetModelAbs get wModelRequired {
    assert(model != null, "$tag: Model no disponible encara");
    return model!;
  }

  bool get hasModel => model != null;

  // OBSERVADOR DEL MODEL =================================
  @override
  void onModelChanged(LdModelAbs model, void Function() pfUpdate) {
    if (ctrl != null) {
      ctrl!.onModelChanged(model, pfUpdate);
    } else {
      pfUpdate();
    }
  }

  // CREACIÓ DE CONTROLADOR ===============================
  @protected
  LdWidgetCtrlAbs createCtrl();

  @override
  State<LdWidgetAbs> createState() => createCtrl();
}
