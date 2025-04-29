// base_widget.dart
// Widget base simplificat per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/taggable_mixin.dart';
import 'package:ld_wbench5/core/lifecycle_interface.dart';
import 'package:ld_wbench5/core/event_system.dart';
import 'package:ld_wbench5/core/base_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Widget base que proporciona funcionalitats comunes
abstract class SabinaWidget extends StatefulWidget with LdTaggable {
  /// Controlador del widget
  final SabinaWidgetController controller;
  
  /// Crea un nou widget base
  SabinaWidget({
    super.key, 
    String? tag,
    required this.controller
  }) {
    if (tag != null) setTag(tag);
    controller.widget = this;
  }
  
  @override
  State<SabinaWidget> createState() => controller;
}

/// Controlador base per als widgets
abstract class SabinaWidgetController<T extends SabinaWidget> extends State<T> 
    with LdTaggable implements LdLifecycle, ModelObserver {
  
  /// Referència al widget
  @override late T widget;
  
  /// Subscripció als events de l'aplicació
  StreamSubscription? _eventSubscription;
  
  /// Inicialitza el controlador
  @override
  void initState() {
    super.initState();
    setTag('${widget.tag}_Controller');
    _eventSubscription = EventBus().events.listen(_handleEvent);
    initialize();
    Debug.info("$tag: Controlador inicialitzat");
  }
  
  /// Processa un event rebut
  void _handleEvent(SabinaEvent event) {
    if (event.isTargetedAt(tag)) {
      Debug.info("$tag: Processant event ${event.type}");
      onEvent(event);
    }
  }
  
  /// Mètode a sobreescriure per gestionar events
  void onEvent(SabinaEvent event);
  
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