// ld_scaffold_ctrl.dart
// Controlador del widget LdScaffold.
// Created: 2025/05/03 ds. JIQ
// Updated: 2025/05/03 ds. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador per al SabinaScaffold
class LdScaffoldCtrl extends LdWidgetCtrlAbs<LdScaffold> {
  /// Barra superior
  final PreferredSizeWidget? appBar;
  
  /// Contingut principal
  final Widget body;
  
  /// Botó flotant
  final Widget? floatingActionButton;
  
  /// Menú lateral
  final Widget? drawer;
  
  /// Constructor
  LdScaffoldCtrl(super.pWidget, {
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.drawer,
  });
  
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador del scaffold");
  }
  
  @override
  void update() {
    // No cal fer res de moment
  }
  
  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Rebut esdeveniment ${event.eType.name}");
    
    // Gestionar canvis d'idioma
    if (event.eType == EventType.languageChanged) {
      Debug.info("$tag: Processant esdeveniment de canvi d'idioma");
      
      // Forçar una reconstrucció del Scaffold
      if (mounted) {
        setState(() {
          Debug.info("$tag: Forçant reconstrucció del Scaffold amb el nou idioma");
        });
      }
    }
    
    // Gestionar reconstrucció global de la UI
    if (event.eType == EventType.rebuildUI) {
      Debug.info("$tag: Processant esdeveniment de reconstrucció de la UI");
      
      if (mounted) {
        setState(() {
          Debug.info("$tag: Reconstruint el Scaffold");
        });
      }
    }
  }
  
  @override
  Widget buildContent(BuildContext context) {
    Debug.info("$tag: Construint Scaffold");
    
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
    );
  }
}