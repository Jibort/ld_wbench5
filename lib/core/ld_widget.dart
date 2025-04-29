// ld_widget.dart
// Widget base simplificat per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/lifecycle_interface.dart';
import 'package:ld_wbench5/core/event_system.dart';
import 'package:ld_wbench5/core/ld_base_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Widget base que proporciona funcionalitats comunes
abstract class LdWidget
extends  StatefulWidget 
with     LdTaggableMixin {
  /// Controlador del widget
  final LdWidgetCtrl<LdWidget> ctrl;
  
  /// Crea un nou widget base
  LdWidget({
    super.key, 
    String? pTag,
    required this.ctrl
  }) {
    if (pTag != null) tag = pTag;
    ctrl.widget = this;
  }
  
  @override
  State<LdWidget> createState() => ctrl;
}

/// Controlador base per als widgets
abstract   class LdWidgetCtrl<T extends LdWidget>
extends    State<T> 
with       LdTaggableMixin
implements LdLifecycle, LdModelObserver {
  /// Referència al widget
  @override late T widget;
  
  /// Subscripció als events de l'aplicació
  StreamSubscription? _eventSubscription;
  
  /// Inicialitza el controlador
  @override initState() {
    super.initState();
    tag = '${widget.tag}_Ctrl';
    _eventSubscription = EventBus().events.listen(_handleEvent);
    initialize();
    Debug.info("$tag: Controlador inicialitzat");
  }
  
  /// Processa un event rebut
  void _handleEvent(LdEvent event) {
    if (event.isTargetedAt(tag)) {
      Debug.info("$tag: Processant event ${event.type}");
      onEvent(event);
    }
  }
  
  /// Mètode a sobreescriure per gestionar events
  void onEvent(LdEvent event);
  
  /// Actualitza el controlador quan canvien les dependències
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Debug.info("$tag: Dependències actualitzades");
    update();
  }
  
  /// Allibera els recursos
  @override
  void dispose() {
    Debug.info("$tag: Alliberant recursos");
    _eventSubscription?.cancel();
    super.dispose();
  }
  
  /// Implementació de ModelObserver
  @override
  void onModelChanged(void Function() updateFunction) {
    if (mounted) {
      setState(updateFunction);
    }
  }
  
  /// Mètode que ha d'implementar cada widget per construir la seva UI
  Widget buildContent(BuildContext context);
  
  /// Construeix el widget
  @override
  Widget build(BuildContext context) => buildContent(context);
}