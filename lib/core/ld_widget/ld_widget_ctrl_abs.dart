// ld_widget_ctrl_abs.dart
// Controlador del Widget base per a l'aplicació.
// Created: 2025/04/29 dt. CLA[JIQ]

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/lifecycle_interface.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador base pels widgets.
abstract   class LdWidgetCtrlAbs<T extends LdWidgetAbs>
extends    State<T> 
with       LdTaggableMixin
implements LdLifecycleIntf, LdModelObserverIntf {
  /// Retorna el widget associat al controlador amb el tipus correcte.
  T get cWidget => widget;
  
  /// Subscripció als events de l'aplicació
  StreamSubscription<LdEvent>? _subcEvent;
  
  /// CONSTRUCTOR ---------------------
  LdWidgetCtrlAbs(T pWidget);

  /// Inicialitza el controlador
  @override initState() {
    super.initState();
    tag = '${widget.tag}_Ctrl';
    _subcEvent = EventBus.s.listen(_handleEvent);
    initialize();
    Debug.info("$tag: Controlador inicialitzat");
  }
  
  /// Processa un event rebut
  void _handleEvent(LdEvent event) {
    if (event.isTargetedAt(tag)) {
      Debug.info("$tag: Processant event ${event.eType.name}");
      onEvent(event);
    }
  }
  
  /// Mètode a sobreescriure per gestionar events
  void onEvent(LdEvent event);
  
  /// 'State': Actualitza el controlador quan canvien les dependències.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Debug.info("$tag: Dependències actualitzades");
    update();
  }
  
  /// 'State': Allibera els recursos.
  @override
  void dispose() {
    Debug.info("$tag: Alliberant recursos ...");
    EventBus.s.cancel(_subcEvent);
    super.dispose();
    Debug.info("$tag: ... Rescursos alliberats");
  }
  
  /// 'LdModelObserverIntf': Notifica que el model ha canviat.
  @override
  void onModelChanged(void Function() updateFunction) {
    if (mounted) setState(updateFunction);
  }
  
  /// 'State': Construeix el widget.
  @override
  Widget build(BuildContext context) => buildContent(context);

  // FUNCIONALITAT ABSTRACTA ----------
  /// Mètode que ha d'implementar cada widget per construir la seva UI
  Widget buildContent(BuildContext context);
  
  
}