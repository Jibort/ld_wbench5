// ld_page_ctrl.dart
// Controlador base per a les pàgines.
// Created: 2025/05/03 ds. JIQ

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/lifecycle_interface.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/once_set.dart';

/// Controlador base per a les pàgines.
abstract   class LdPageCtrl<T extends LdPageAbs>
extends    State<T> 
with       LdTaggableMixin
implements LdLifecycleIntf, LdModelObserverIntf {
  /// Referència a la pàgina
  final OnceSet<T> _page = OnceSet<T>();
  /// Retorna la referència a la pàgina del controlador.
  T get cPage => _page.get(pCouldBeNull: false)!;
  /// Estableix la referència a la pàgina del controlador.
  set cPage(T pPage) => _page.set(pPage);

  /// Subscripció als events de l'aplicació
  StreamSubscription<LdEvent>? _subcEvent;
  
  /// Constructor
  LdPageCtrl({ String? pTag, required T pPage }) {
    tag = (pTag != null)
      ? pTag
      : className;
    cPage = pPage;
  }

  /// Inicialitza el controlador
  @override
  void initState() {
    super.initState();
    tag = '${cPage.tag}_Ctrl';
    _subcEvent = EventBus.s.listen(_handleEvent);
    initialize();
    Debug.info("$tag: Controlador inicialitzat");
  }
  
  /// Processa un event rebut
  void _handleEvent(LdEvent event) {
    // Eliminar el filtratge per tag en events globals importants
    if (event.eType == EventType.languageChanged || 
        event.eType == EventType.themeChanged || 
        event.eType == EventType.rebuildUI || 
        event.isTargetedAt(tag)) {
      Debug.info("$tag: Processant event ${event.eType.name}");
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
    EventBus.s.cancel(_subcEvent);
    super.dispose();
  }
  
  /// Implementació de ModelObserver
  @override
  void onModelChanged(void Function() pfUpdate) {
    Debug.info("$tag.onModelChanged(): executant ...");
    if (mounted) {
      setState(pfUpdate);
    } else {
      pfUpdate();
    }
    Debug.info("$tag.onModelChanged(): ... executat");
  }
  
  /// Mètode que ha d'implementar cada pàgina per construir la seva UI
  Widget buildPage(BuildContext context);
  
  /// Construeix la pàgina
  @override
  Widget build(BuildContext context) => buildPage(context);
}