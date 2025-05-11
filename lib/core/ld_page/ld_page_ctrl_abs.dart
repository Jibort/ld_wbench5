// ld_page_ctrl_abs.dart
// Controlador base per a les pàgines.
// Created: 2025/05/03 ds. JIQ
// Updated: 2025/05/11 ds. CLA - Optimització amb gestió de model i GlobalKey
// Updated: 2025/05/11 ds. CLA - Correcció de noms i tipus genèrics

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/lifecycle_interface.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador base abstracte per a les pàgines.
abstract class LdPageCtrlAbs<T extends LdPageAbs>
    extends State<T> 
    with LdTaggableMixin
    implements LdLifecycleIntf, LdModelObserverIntf {
  
  /// Model de la pàgina
  LdPageModelAbs? _model;
  
  /// Getter públic per accedir al model
  LdPageModelAbs? get model => _model;
  
  /// Setter per assignar el model
  @protected
  set model(LdPageModelAbs? newModel) {
    if (_model != newModel) {
      // Desregistrar-se de l'antic model si existeix
      if (_model != null) {
        _model!.detachObserver(this);
      }
      
      // Assignar el nou model
      _model = newModel;
      
      // Registrar-se com a observador del nou model
      if (_model != null) {
        _model!.attachObserver(this);
      }
      
      Debug.info("$tag: Model de pàgina actualitzat");
    }
  }
  
  /// Referència a la pàgina
  T get cPage => widget;

  /// Subscripció als events de l'aplicació
  StreamSubscription<LdEvent>? _subcEvent;
  
  /// Constructor
  LdPageCtrlAbs({ String? pTag, required T pPage }) {
    tag = (pTag != null)
      ? pTag
      : className;
  }

  /// Inicialitza el controlador
  @override
  void initState() {
    super.initState();
    tag = '${cPage.tag}_Ctrl';
    _subcEvent = EventBus.s.listen(_handleEvent);
    
    // Crear el model si la pàgina ho requereix
    _createModelIfNeeded();
    
    initialize();
    Debug.info("$tag: Controlador de pàgina inicialitzat");
  }
  
  /// Crea el model de la pàgina si és necessari
  /// Aquest mètode ha de ser sobreescrit per les subclasses per crear un model específic
  @protected
  void _createModelIfNeeded() {
    // Implementació base buida
    // Les subclasses haurien de sobreescriure aquest mètode per crear el seu model específic
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
  
  /// Gestiona l'actualització del widget quan canvien les propietats
  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Verificar si necessitem actualitzar quelcom de la pàgina
    // Per defecte, les pàgines no tenen una configuració tan dinàmica com els widgets
    Debug.info("$tag: Pàgina actualitzada");
  }
  
  /// Allibera els recursos
  @override
  void dispose() {
    Debug.info("$tag: Alliberant recursos de la pàgina...");
    
    // Cancelar subscripció a events
    EventBus.s.cancel(_subcEvent);
    
    // Desregistrar-se del model
    if (_model != null) {
      _model!.detachObserver(this);
      _model!.dispose();
      _model = null;
    }
    
    super.dispose();
    Debug.info("$tag: Recursos de la pàgina alliberats");
  }
  
  /// Notificació de canvi en un model
  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
    Debug.info("$tag.onModelChanged(): executant ...");
    
    // Executar l'actualització sempre
    pfUpdate();
    
    // Però només reconstruir si està muntat
    if (mounted) {
      setState(() {
        Debug.info("$tag.onModelChanged(): Reconstruint widget");
      });
    }
    
    Debug.info("$tag.onModelChanged(): ... executat");
  }

  /// Construeix la pàgina
  @override
  Widget build(BuildContext context) {
    Debug.info("$tag: Construint pàgina");
    return buildPage(context);
  }
  
  /// Mètode que ha d'implementar cada pàgina per construir la seva UI
  Widget buildPage(BuildContext context);
  
  // UTILITATS DE NAVEGACIÓ I CONTEXT =========================================
  // Aquestes utilitats hereten del mixin LdTaggableMixin
  
  /// Accés directe al context de la pàgina
  BuildContext get pageContext => context;
  
  /// Mostra un SnackBar específic de la pàgina
  void showPageSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(pageContext).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }
  
  /// Mostra un diàleg modal des de la pàgina
  Future<R?> showPageDialog<R>({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
  }) async {
    return await showDialog<R>(
      context: pageContext,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }
  
  /// Tanca la pàgina actual
  void closePage([dynamic result]) {
    Navigator.of(pageContext).pop(result);
  }
  
  /// Navega a una nova pàgina amb animación
  void navigateToPage(
    Widget destination, {
    bool replace = false,
    bool clearStack = false,
    RouteTransitionsBuilder? transitionBuilder,
  }) {
    Route<dynamic> route;
    
    if (transitionBuilder != null) {
      route = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: transitionBuilder,
      );
    } else {
      route = MaterialPageRoute(builder: (_) => destination);
    }
    
    if (clearStack) {
      Navigator.of(pageContext).pushAndRemoveUntil(route, (route) => false);
    } else if (replace) {
      Navigator.of(pageContext).pushReplacement(route);
    } else {
      Navigator.of(pageContext).push(route);
    }
  }
  
  /// Mostra un bottom sheet des de la pàgina
  Future<R?> showPageBottomSheet<R>({
    required Widget Function(BuildContext) builder,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
  }) async {
    return await showModalBottomSheet<R>(
      context: pageContext,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      builder: builder,
    );
  }
}