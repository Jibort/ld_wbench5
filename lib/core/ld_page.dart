// ld_page.dart
// Pàgina base simplificada per a l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/lifecycle_interface.dart';
import 'package:ld_wbench5/core/event_system.dart';
import 'package:ld_wbench5/core/ld_base_model.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/once_set.dart';

/// Pàgina base que proporciona funcionalitats comunes
abstract class LdPage
extends  StatefulWidget
with     LdTaggableMixin {
  /// Controlador de la pàgina
  final LdPageCtrl ctrl;
  
  /// Crea una nova pàgina base
  LdPage({
    super.key, 
    String? pTag,
    required this.ctrl })
  { if (pTag != null) tag = pTag;
    ctrl.page = this;
  }
  
  @override
  State<LdPage> createState() => ctrl;
}

/// Controlador base per a les pàgines
abstract   class LdPageCtrl<T extends LdPage>
extends    State<T> 
with       LdTaggableMixin
implements LdLifecycle, LdModelObserver {
  /// Referència a la pàgina
  final OnceSet<T> _page = OnceSet<T>();
  /// Retorna la referència a la pàgina del controlador.
  T get page => _page.get();
  /// Estableix la referència a la pàgina del controlador.
  set page(T pPage) => _page.set(pPage);

  /// Subscripció als events de l'aplicació
  StreamSubscription? _subcEvent;
  
  /// Inicialitza el controlador
  @override
  void initState() {
    super.initState();
    tag = '${page.tag}_Ctrl';
    _subcEvent = EventBus().events.listen(_handleEvent);
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
    _subcEvent?.cancel();
    super.dispose();
  }
  
  /// Implementació de ModelObserver
  @override
  void onModelChanged(void Function() updateFunction) {
    if (mounted) {
      setState(updateFunction);
    }
  }
  
  /// Mètode que ha d'implementar cada pàgina per construir la seva UI
  Widget buildPage(BuildContext context);
  
  /// Construeix la pàgina
  @override
  Widget build(BuildContext context) => buildPage(context);
}